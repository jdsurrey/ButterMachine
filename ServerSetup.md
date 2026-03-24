# Server Migration Guide

Servers can be dropped off on-site early, before the scheduled install day. This allows significant pre-work to be completed, minimizing on-site time. Some tasks are disruptive; others are not. This guide covers both types, with the assumption that disruptive work will occur on the scheduled day unless additional downtime is available.

---

## Quick Reference: Task Categories

### Non-Disruptive Tasks (Can be done anytime)
- FRS to DFSR Migration
- DHCP Migration
- File Migration (initial copy)
- Folder Redirection policy updates (Step 1 only)

### Disruptive Tasks (Schedule for downtime)
- AD DS: IP changes, DNS re-registration, server demotion
- DHCP: Final DNS pointer updates
- Mapped drive migration
- Folder Redirection: Final data migration and policy updates

---

# Section 1: Active Directory Domain Services (AD DS) Migration

## Prerequisites

If adding a Server 2019 server to an older domain, you may need to migrate from FRS to DFSR. This is **non-disruptive** and can be done before your scheduled install day.

## Section 1.1: FRS to DFSR Migration

#### Summary

FRS and DFSR replicate files within Active Directory between domain controllers. FRS is no longer supported—it was deprecated in Server 2008 R2 and does not function on Server 2019. Attempting to add a Server 2019 DC to an FRS-based domain will fail.

#### Prerequisites for FRS to DFSR Migration

- Ensure you have a current backup before proceeding
- If you have multiple domain controllers, allow AD replication to complete between each step before proceeding to the next step

#### Migration Steps

##### Step 1: Migrate to "Prepared" State
```
dfsrmig /setglobalstate 1
dfsrmig /getmigrationstate
```
**Expected result:** All domain controllers show "Prepared" status

##### Step 2: Migrate to "Redirected" State
```
dfsrmig /setglobalstate 2
dfsrmig /getmigrationstate
```
**Expected result:** All domain controllers show "Redirected" status

##### Step 3: Migrate to "Eliminated" State
```
dfsrmig /setglobalstate 3
dfsrmig /getmigrationstate
```
**Expected result:** All domain controllers show "Eliminated" status. Migration complete.

---

## Section 1.2: Reset DSRM Password (if needed)

Don't know the DSRM password and neither does the office? Reset it using the following procedure:

1. Open Run dialog (Start > Run), type `ntdsutil`, and press OK
2. At the Ntdsutil command prompt, type: `set dsrm password`
3. At the DSRM command prompt, choose one of the following:
   - For local computer: `reset password on server null`
   - For remote computer: `reset password on server servername`
4. Enter the new password when prompted (no characters will display)
5. At the DSRM command prompt, type `q`
6. At the Ntdsutil command prompt, type `q` to exit

---

## Section 1.3: AD DS Migration Process

Familiarize yourself with the migration process before proceeding. If necessary, run through this process in a lab first so you understand it.

#### Key Point: Concurrent Domain Controllers

Active Directory fully supports multiple concurrent domain controllers and replication between them. Because of this, you can do a large amount of this work beforehand, in a non-disruptive manner.

#### Non-Disruptive Tasks (Can be done before install day)
- Adding the new server as a secondary DC
- Confirming functionality and fixing replication (if necessary)
- Migrating the FSMO roles
- *Note: This also replicates the Active Directory Integrated DNS Zones automatically*

#### Disruptive Tasks (Schedule for install day)
- Changing the server's IP address and re-registering DNS
- Demoting the old server
- Changing DHCP to point to the correct DNS servers

---

## Section 1.4: Configure Network Location Awareness (NLA)

### Problem

Often times when a server boots up, the Network Location Awareness service will start before DNS does. When this happens, it will set the network type to private instead of domain. Trying to restart the NLA service will fail as it relies upon a Network List service which won't restart.

### Solution

Run the following command from an administrative command prompt, then reboot the server. Doing this will make the NLA service dependent upon DNS.

```
sc config nlasvc depend=DNS
```

### Troubleshooting: If Issues Persist

If you are still having issues after running the command above, you can also add the DNS Suffix for connections on the server:

1. Go to your Ethernet connection settings
2. Navigate to TCP/IP V4
3. Click Advanced
4. Add the DNS suffix for the domain

---

# Section 2: DHCP Migration

DHCP is very easy to migrate and can be done at any time. Using an export/import method preserves current DHCP leases, scopes, and all configurations. Devices will simply use the new DHCP server when they need to renew leases, so long as a device isn't literally trying to get a lease right when the migration happens (a rare occurrence).

## Process

Export DHCP configuration from the old server and import it into the new server.

## Best Practice

Test this process in a lab environment before trying it in the field.

---

# Section 3: File Migration

You can start the file transfer process from one server to another very easily and with little to no impact on users. While the initial copy shouldn't yet be used (as users are still modifying data on the old server), it should drastically cut down on the time required to run an incremental transfer on your install day.

## Why start early?

No matter what method you're using, simply monitor it to make sure your initial "full" copy finishes correctly, so your day-of incremental is quick. Last thing you want is to arrive on the day-of and have to wait hours for data transfer.

## File Transfer Methods

### Robocopy (Command Line)

```
robocopy "source" "destination" /MIR /B /COPYALL /R:1 /W:1
```

### SyncBackSE (GUI)

Download and test before deploying in production.

### FreeFileSync (GUI)

Open-source file synchronization tool that provides a simple interface for bi-directional syncing with support for preserving file permissions.

---

## Section 3.1: Guide to Using FreeFileSync for Data Migration

### 1. Install FreeFileSync

**Install FreeFileSync on the Old Server**
- Download FreeFileSync from https://freefilesync.org/
- Run the executable as administrator
- Click next all the way through the installation wizard

### 2. Create "General" File on New Server

- Remote into the new server
- On the D Drive, create a folder called "Older Server"
- Share the file with read/write permissions for "Everyone"
- Inside that folder, create 2 new folders:
  - `C Drive`
  - `D Drive`

### 3. Create Specific File Shares (Optional)

If you want to save time and are confident in the files you want to migrate, you can create specific file shares for 1-to-1 folder mapping.

**Example:**
- `shared`
- `users`
- `Eaglesoft DATA`

Create these folders in the D Drive on the new server and share them with "Everyone" with read/write permissions.

### 4. Configure FreeFileSync

1. Open FreeFileSync
2. On the left side, add the folders you want to sync
   - Click the plus sign to add more than one
3. On the right side, browse to the new server and select the file you want to copy data to
4. Click the **Gear Icon**
5. On the **Comparison tab**, select "Ignore errors"
6. Go to the **Synchronization tab**
7. Click **Mirror**
8. Click OK
9. Click the **Save as Batch Job** button
10. Select **Run and minimized** and **auto close**
11. Click **Save As**
12. Click **Compare**
    - This could take a while, just wait
13. After it's finished comparing, **Synchronize** will turn green
    - Click it
14. Click OK

### 5. Setup Batch Job to Auto Sync at Night

**Create Task in Task Scheduler**

1. Open the **Task Scheduler**
2. Create a new **Basic Task**
3. Follow the wizard through to completion
4. Make the **Program/script** point to the location of FreeFileSync.exe
   - Usually: `C:\Program Files\FreeFileSync\FreeFileSync.exe`
5. In the **Add Arguments** section, add the link to the ffs_batch file you created earlier
   - Example: `"D:\datamig.ffs_batch"`
   - **Important: Use quotation marks to protect spaces in path names**

**Configure Task Settings**

After the task is created, open it and click on the **Settings page**, then set the following options as needed for your environment.

---

# Section 4: Mapped Drive Migration

**Status:** Disruptive task—schedule for install day.

## Process

Once you have files migrated to the new server, you can set up file shares and deploy new mapped drives. Your steps are:

1. Migrate all the data to the new server
2. Move the data into a correct path (e.g., `D:\FileShares\CompanyShared`)
3. Share the folder out with the correct SMB permissions
4. Adjust NTFS file permissions, if necessary
5. Remove the share from the old server (but do NOT delete the data)
6. Update Group Policy to reflect the new path for the mapped drives

## User Experience

The next time users log in, they will get the new mapped drive path, and this should be completely seamless to them. Since mapped drive letters do not change, all paths on the local computer remain the same. Since the old server is un-shared, users won't accidentally modify the old server, eliminating the chance of data loss.

---

# Section 5: Folder Redirection Migration

Folder Redirection stores user profile data (Documents, Desktop, etc.) on a server rather than locally. This migration requires careful planning and execution in several phases.

## Timeline

These steps should be performed several days before the scheduled downtime of the server install, if possible. They can also be performed day-of if necessary.

---

## Step 1: Change Policy to NOT Move Files

**Timing:** Several days before or day-of migration (Non-Disruptive)

This step prevents workstations from attempting to move files to the new location when they receive the updated policy. Without this step, users' computers would try to reach the old server.

1. Open Group Policy Management
2. Find the Folder Redirection GPO and edit it
3. Navigate to: User Configuration > Policies > Windows Settings > Folder Redirection
4. For each section (Desktop, Documents, etc.), open the Properties of the policy
5. Go to the Settings tab
6. **UNCHECK** the box "Move the contents of [folder] to the new location"
7. Under Policy Removal, choose "Leave the folder in the new location when policy is removed"

**Result:** When workstations log in with the new path, they won't try to reach out to the old server and will simply pick up the new one.

---

## Step 2: Update Group Policy

**Timing:** Before continuing to Step 3 (Non-Disruptive)

Before continuing, make sure Group Policy updates on all workstations. Folder Redirection policy only updates when users log in.

**Recommendation:** Schedule a reboot for after business hours or early morning to ensure all workstations receive the policy update.

---

## Step 3: Migrate the Data

**Timing:** Several days before or outside business hours (Non-Disruptive if done outside hours)

Using Robocopy, SyncBackSE, FreeFileSync, or the Datto Direct Restore Utility, migrate all the data from the old share to the new server.

**Important:** You must preserve file permissions during the migration.

As this is data that users are working on, you'll need to either:
- Do this outside of business hours, OR
- Do an initial "full" copy now and an "incremental" copy before your cut-over time

### Using RoboCopy for Exclusive Access Mode

If someone set up the option "Grant Exclusive Access to..." on the share, you won't be able to just do a regular file copy. Use this command on the OLD server:

```
robocopy "D:\FolderRedirectionPath" "\\NewServer\d$\NewFolderRedirectionPath" /MIR /B /COPYALL /SL /XJ /R:1 /W:1 /LOG:D:\FolderRedirection.log /TEE /ETA
```

**Important:** Change the paths to match your environment:
- First path: Your current Folder Redirection path
- Second path: The new server's Folder Redirection folder

---

## Step 4: Share the Folder

**Timing:** Before cut-over day (Non-Disruptive)

1. On the new server, create the Folder Redirection share
2. Use a hidden share name (one that ends in `$`)
3. Allow all Authenticated Users access
4. Do not change the NTFS permissions at this stage

---

## Step 5: Check Permissions

**Timing:** Before cut-over day (Non-Disruptive)

Check the folder permissions carefully:
- The internal folders should only be accessible to each individual user
- Do NOT replace child permissions
- You can verify permissions by logging in as a test user

**Permission Reference:**

| Principal | Permission | Apply To |
|-----------|-----------|----------|
| CREATOR OWNER | Full Control | Subfolders and Files Only |
| SYSTEM | Full Control | This Folder, Subfolders and Files |
| Domain Admins | Full Control | This Folder, Subfolders and Files |
| Everyone | Traverse Folder/Execute File, List Folder/Read Data, Read Attributes, Create Folder/Append Data | This Folder Only |

---

## Step 6: Update the Policy

**Timing:** During scheduled downtime (Disruptive)

This step must be done outside of business hours or during scheduled downtime.

1. In Group Policy, update all Folder Redirection paths to point to the new server
2. Update both Desktop and Documents (and any other redirected folders)

---

## Step 7: Update Group Policy and Test

**Timing:** During/after cut-over (Disruptive)

The next time users log in, their user profile data will simply point to the new server and all should work well.

1. Push out `gpupdate /force` to all workstations
2. Have users log in and verify everything works
3. Test a user logon or two to confirm data appears correctly
4. Check that files are on the new server, not local machines

---

## Troubleshooting: Legacy "My Documents" Folders

In some cases, you may run into issues if Folder Redirection was created from older versions of Windows that still used the "My Documents" folder. If the Folder Redirection data includes "My Documents" folders, users will find their data is missing when they log in.

If this occurs, run this PowerShell script beforehand:

```powershell
# Change this directory to wherever you are pointing your Folder Redirection to
$dir = dir D:\FolderRedirection | ?{$_.PSISContainer}
foreach ($d in $dir) {
    # Rename the "My Documents" folder to just Documents to match Win7+
    $path = Join-Path $d.FullName -ChildPath ("\My Documents")
    $NewPath = Join-Path $d.FullName -ChildPath ("\Documents")
    Move-Item $path $NewPath
    
    # Do the same with "My Pictures" > Pictures
    $path = Join-Path $d.FullName -ChildPath ("\My Pictures")
    $NewPath = Join-Path $d.FullName -ChildPath ("\Pictures")
    Move-Item $path $NewPath
}
```

**Customization:** 
- Change the `$dir` value to match your Folder Redirection data location
- This script by default moves both "My Documents" and "My Pictures" into their modern equivalents
- You may need to customize the script to match your specific needs

---

# Section 5.1: Folder Redirection Setup (Detailed)

These steps establish the Folder Redirection infrastructure. Perform them outside business hours to ensure full access to accounts and servers.

## Prerequisites

- Have logins ready for user accounts and the server
- **Back up all user profiles on every machine before proceeding**

## Step 1: Create Folder Redirection Share on Server

1. Log into the server
2. Create a new folder on the data partition: `FolderRedirection`
3. Right-click > Properties > Sharing > Advanced Sharing
4. Share name: `FolderRedirection$` (the $ makes it hidden)
5. Permissions: Set Everyone to Full Control
6. Go back to Properties > Security > Advanced > Change Permissions
7. Uncheck "Include inheritable permissions from this object's parent"
   - Or click "Disable inheritance" on Server 2019 and select "Convert inherited permissions"
8. Set the following explicit permissions:

| Principal | Permission | Apply To |
|-----------|-----------|----------|
| CREATOR OWNER | Full Control | Subfolders and Files Only |
| SYSTEM | Full Control | This Folder, Subfolders and Files |
| Domain Admins | Full Control | This Folder, Subfolders and Files |
| Everyone | Traverse Folder/Execute File, List Folder/Read Data, Read Attributes, Create Folder/Append Data | This Folder Only |

## Step 2: Create Active Directory Users and OUs

1. Open Active Directory Users and Computers
2. Create a new OU for users (e.g., "[Organization] Users")
3. Create individual user accounts for each workstation/person (e.g., Front1, OP1, Doctor)
4. Each user must have a unique logon—**DO NOT use shared login accounts with Folder Redirection**
5. **DO NOT make these users Administrators or Domain Admins**
6. Create a separate OU for Computers and move applicable workstations into it

### Critical Warning

**BEFORE proceeding further, back up every user profile on every machine. This is essential.**

## Step 3: Create Folder Redirection Group Policy Object

1. Open Group Policy Management
2. Right-click on the Users OU > "Create a GPO in this domain, and Link it here"
3. Name it: `Folder Redirection`
4. Edit the newly created GPO
5. Navigate to: User Configuration > Policies > Windows Settings > Folder Redirection

### Configure Desktop Folder

1. Right-click Desktop > Properties
2. Setting: Basic - Redirect everyone's folder to the same location
3. Target Folder Location: Create a folder for each user under root path
4. Root Path: Enter UNC path (e.g., `\\server\FolderRedirection$`)
5. Go to Settings tab
6. **UNCHECK:** "Grant the user exclusive rights to Desktop"
7. **CHECK:** "Move the contents of Desktop to the new location"
8. Policy Removal: "Leave the folder in the new location when policy is removed"
9. Click OK

### Configure Documents Folder

Repeat the same process for Documents. For Music, Pictures, and Videos, select "Follow the Documents folder."

## Step 4: Create LAN Zone Group Policy

Prevents users from receiving security warnings when opening files on their desktop.

1. Create new GPO under Computers OU: `Folder Redirection LAN Zone`
2. Navigate to: Computer Configuration > Policies > Administrative Templates > Windows Components > Internet Explorer > Internet Control Panel > Security Page
3. Set Site to Zone Assignment List:
   - Add both short and full server names as value names
   - Set Value to 1 for both
4. Set Intranet zone security settings:
   - Show security warning for potentially unsafe files: **Enabled**
   - Launching programs and unsafe files: **Enable**

## Step 5: Disable Offline Files

Offline Files can break and cause synchronization issues, leading to data loss. Disabling them ensures users always work with the latest copy.

### Via Group Policy (Domain-Wide)

Create GPO: `Disable Offline Files` at domain root

**Computer Configuration > Policies > Administrative Templates > Network > Offline Files:**
- Allow or Disallow use of Offline Files feature: **Disabled**
- Prevent use of Offline Files folder: **Enabled**
- Prohibit user configuration of Offline Files: **Enabled**
- Remove "Make Available Offline" command: **Enabled**
- Synchronize all offline files before logoff: **Disabled**
- Synchronize all offline files when logging on: **Disabled**
- Synchronize offline files before suspend: **Disabled**

**User Configuration > Policies > Administrative Templates > Network > Offline Files:**
- Prohibit user configuration of Offline Files: **Enabled**
- Remove "Make Available Offline" command: **Enabled**
- Remove "Work offline" command: **Enabled**

**User Configuration > Policies > Administrative Templates > System > Folder Redirection:**
- Do not automatically make all redirected folders available offline: **Enabled**
- Enable optimized move of contents in Offline Files cache on path change: **Enabled** *(Windows 8+ only)*

### Via Share Settings (Local)

1. Open `MMC.exe`
2. File > Add/Remove Snap-ins > Shared Folders (local computer)
3. Navigate to: Shared Folders > Shares
4. Double-click `FolderRedirection$`
5. Click "Offline Settings"
6. Select: "No files or programs from the shared folder are available offline"

## Step 6: Apply Policy and Migrate Users

1. Run `gpupdate /force` on all workstations
2. Reboot all workstations to fully disable Offline Files
3. Use ProfWiz to migrate user profiles
4. Windows will automatically move local data into the new `FolderRedirection$` share

## Step 7: Test

1. Log into each workstation (first logon will take time due to data migration)
2. Check files in Documents and Desktop
3. Verify locations are on the server, not local (e.g., `\\server\FolderRedirection$`)
4. If still showing local path (`C:\Users\...`), check Event Viewer for errors

## Step 8: Document Setup

Create documentation and record:
- Servers hosting the Folder Redirection share
- File shares and paths
- Name of the Group Policy Object
- OU filtering/targeting, or if policy applies to all users
- Update Group Policy documentation
