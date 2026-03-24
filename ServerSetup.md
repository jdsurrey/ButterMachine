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

You will also want to ensure Network Location Awareness doesn't start too soon and cause the network type to be set to private instead of domain.

**Quick Fix:** Run the following command from an administrative command prompt, then reboot:

```
sc config nlasvc depend=DNS
```

If issues persist, go to the Ethernet connection settings > TCP/IP V4 > Advanced and add the DNS suffix for the domain.

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

### SyncBack (GUI)

Download a trial version for testing before deploying in production.

### Solarwinds MSP Backup (Continuous Restore)

Use the Backup Recovery Console to run a Continuous Restore, which will produce a "live" copy of the data, up to date as soon as a backup is run.

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

Familiarize yourself with Folder Redirection and the existing migration documentation before proceeding.

## Phase 1: Pre-Migration (Before install day - Non-Disruptive)

### Step 1: Update Group Policy (Non-Disruptive)

The main thing you're going to want to do is change the policy to **NOT move files to the new location**. You want to do this before the day-of so that computers can update to the new policy.

1. Open Group Policy Management
2. Find and edit the Folder Redirection GPO
3. Navigate to: User Configuration > Policies > Windows Settings > Folder Redirection
4. For each section (Desktop, Documents, etc.), open Properties and go to Settings tab
5. **UNCHECK:** "Move the contents of [folder] to the new location"
6. Under Policy Removal, select: "Leave the folder in the new location when policy is removed"
7. Allow all workstations to receive this policy update (typically at next logon)

### Step 2: Migrate Data (Non-Disruptive)

You can also do a copy of the Folder Redirection data beforehand using any method from **Section 3: File Migration**:
- Robocopy
- SyncBack
- Solarwinds MSP Backup (Continuous Restore)

Preserve file permissions during the transfer.

### Step 3: Verify Folder Setup

**Very Important:** When setting this back up, be very mindful of NTFS folder permissions! Review the setup documentation to see what the share and NTFS permissions should be.

See **Section 5.1: Folder Redirection Setup (Detailed)** below for complete configuration instructions.

## Phase 2: Final Migration (Install day - Disruptive)

If you have disruptive downtime available beforehand, you can run through the rest of the folder redirection migration early. Once all computers know NOT to move files to the new location, you can:

1. Move the files to the new server
2. Update the policies to point to the new location
3. Push out a `gpupdate /force` to all computers
4. Test thoroughly

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

### ⚠️ Critical Warning

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
