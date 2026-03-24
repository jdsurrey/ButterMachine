# Server Migration Guide

**How to Perform Smooth Server Migrations and Minimize User Downtime**

---

## Overview

Servers can be dropped off on-site early, before the scheduled install day. This allows significant pre-work to be completed, minimizing on-site time. Some tasks are disruptive; others are not. This guide covers both types, with the assumption that disruptive work will occur on the scheduled day unless additional downtime is available.

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

If adding a Server 2019 DC to an older domain using FRS (File Replication Service), you must migrate to DFSR first. See Section 1.1 below.

## Section 1.1: FRS to DFSR Migration

### Summary

FRS and DFSR replicate files within Active Directory between domain controllers. FRS is no longer supported—it was deprecated in Server 2008 R2 and does not function on Server 2019. Attempting to add a Server 2019 DC to an FRS-based domain will fail.

### Prerequisites for FRS to DFSR Migration

- Ensure you have a current backup before proceeding
- If you have multiple domain controllers, allow AD replication to complete between each step before proceeding to the next step

### Migration Steps

#### Step 1: Migrate to "Prepared" State
```
dfsrmig /setglobalstate 1
dfsrmig /getmigrationstate
```
**Expected result:** All domain controllers show "Prepared" status

#### Step 2: Migrate to "Redirected" State
```
dfsrmig /setglobalstate 2
dfsrmig /getmigrationstate
```
**Expected result:** All domain controllers show "Redirected" status

#### Step 3: Migrate to "Eliminated" State
```
dfsrmig /setglobalstate 3
dfsrmig /getmigrationstate
```
**Expected result:** All domain controllers show "Eliminated" status. Migration complete.

---

## Section 1.2: Reset DSRM Password (if needed)

If the DSRM password is unknown, reset it using the following procedure.

### Procedure

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

Familiarize yourself with the AD DS migration process before proceeding. If possible, test in a lab environment first.

### Non-Disruptive Tasks (Can be done before install day)
- Add new server as secondary domain controller
- Confirm functionality and fix replication if needed
- Migrate FSMO roles
- *Note: AD Integrated DNS zones replicate automatically*

### Disruptive Tasks (Schedule for install day)
- Change new server IP address and re-register DNS
- Demote old server
- Update DHCP to point to correct DNS servers

### Important: Network Location Awareness (NLA)

Configure NLA to depend on DNS to prevent the network type from being set to private instead of domain. See Section 1.4 below.

---

## Section 1.4: Configure Network Location Awareness

### Problem

When a server boots, the Network Location Awareness service may start before DNS. This causes the network type to be set to private instead of domain. Attempting to restart NLA will fail as it depends on the Network List service.

### Solution

Run the following command from an administrative command prompt, then reboot:

```
sc config nlasvc depend=DNS
```

### Additional troubleshooting (if issues persist)

Go to the Ethernet connection settings > TCP/IP V4 > Advanced and add the DNS suffix for the domain.

---

# Section 2: DHCP Migration

DHCP migration is straightforward and can be done at any time with zero user impact. Using an export/import method preserves current leases, scopes, and all configurations. Devices will simply use the new DHCP server when renewing leases.

## Process

Export DHCP configuration from the old server and import it into the new server. Detailed instructions are available in the IT Glue knowledge base.

## Best Practice

Test this process in a lab environment before deploying to production.

---

# Section 3: File Migration

File transfers can be started early with minimal user impact. While users continue modifying data on the old server, an initial copy significantly reduces the time required for the day-of incremental transfer.

## Why start early?

Monitor the initial full copy to ensure it completes correctly. This ensures the day-of incremental transfer is quick. Arriving on site only to wait hours for data transfer defeats the purpose of early preparation.

## File Transfer Methods

- **Robocopy (Command Line)** - Detailed in IT Glue knowledge base
- **SyncBackSE (GUI)** - Trial version available for testing
- **Solarwinds MSP Backup** - Use Backup Recovery Console for Continuous Restore to create a live, up-to-date copy

---

# Section 4: Mapped Drive Migration

**Status:** Disruptive task—schedule for install day.

## Process

1. Ensure all data is migrated to the new server (see Section 3)
2. Organize data in the correct path structure (e.g., `D:\FileShares\CompanyShared`)
3. Create file shares on new server with correct SMB permissions
4. Adjust NTFS file permissions as needed
5. Remove shares from old server (do NOT delete data)
6. Update Group Policy to reflect new mapped drive paths
7. Users receive new mapped drive path at next logon—completely seamless

## User Impact

Because mapped drive letters do not change, all user paths remain the same. Removing shares from the old server prevents accidental modifications and eliminates data loss risk.

---

# Section 5: Folder Redirection Migration

Folder Redirection stores user profile data (Documents, Desktop, etc.) on a server rather than locally. Migration requires careful planning and execution.

## Phase 1: Pre-Migration (Several days before or day-of)

### Step 1: Update Group Policy (Non-Disruptive)

Update Folder Redirection policy to NOT move files to the new location. This allows workstations to update policy before the migration, preventing them from attempting to reach the old server.

1. Open Group Policy Management
2. Find and edit the Folder Redirection GPO
3. Navigate to: User Configuration > Policies > Windows Settings > Folder Redirection
4. For each section (Desktop, Documents, etc.), open Properties and go to Settings tab
5. **UNCHECK:** "Move the contents of [folder] to the new location"
6. Under Policy Removal, select: "Leave the folder in the new location when policy is removed"
7. Allow all workstations to receive this policy update (typically at next logon)

### Step 2: Migrate Data (Non-Disruptive for initial copy)

Begin copying Folder Redirection data to the new server using Robocopy, SyncBackSE, Solarwinds Recovery Console, or Datto Direct Restore Utility. Preserve file permissions.

**Note:** If exclusive access is enabled ("Grant Exclusive Access to..."), use the RoboCopy command below:

```
robocopy "D:\FolderRedirectionPath" "\\NewServer\d$\NewFolderRedirectionPath" /MIR /B /COPYALL /SL /XJ /R:1 /W:1 /LOG:D:\FolderRedirection.log /TEE /ETA
```

Replace paths as appropriate for your environment.

### Step 3: Verify Folder Setup

On the new server, create/verify the Folder Redirection share with proper permissions. See Section 5.1 below for detailed setup instructions.

## Phase 2: Final Migration (Install day—Disruptive)

### Step 4: Update Group Policy with New Paths

Update all Folder Redirection policy paths to point to the new server.

### Step 5: Apply Updates and Test

1. Push Group Policy update to all workstations (`gpupdate`)
2. Users will see new paths at next logon
3. Test by logging in as a user and verifying file locations are on the new server
4. Check Event Viewer if any folders failed to redirect

### Troubleshooting: Legacy "My Documents" Folders

If Folder Redirection data includes legacy "My Documents" folders (from older Windows), users will see missing data. Run the PowerShell script below beforehand:

```powershell
# Change this directory to wherever you are pointing Folder Redirection
$dir = dir D:\FolderRedirection | ?{$_.PSISContainer}
foreach ($d in $dir) {
    $path = Join-Path $d.FullName -ChildPath "\My Documents"
    $NewPath = Join-Path $d.FullName -ChildPath "\Documents"
    Move-Item $path $NewPath
    $path = Join-Path $d.FullName -ChildPath "\My Pictures"
    $NewPath = Join-Path $d.FullName -ChildPath "\Pictures"
    Move-Item $path $NewPath
}
```

Customize as needed for your environment.

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
3. Use ProfWiz to migrate user profiles (see IT Glue USMT guide)
4. Windows will automatically move local data into the new `FolderRedirection$` share

## Step 7: Test

1. Log into each workstation (first logon will take time due to data migration)
2. Check files in Documents and Desktop
3. Verify locations are on the server, not local (e.g., `\\server\FolderRedirection$`)
4. If still showing local path (`C:\Users\...`), check Event Viewer for errors

## Step 8: Document Setup

Create an IT Glue entry titled "Folder Redirection" and document:
- Servers hosting the Folder Redirection share (tag them)
- File shares and paths (create entries under File Sharing, tag them)
- Name of the Group Policy Object
- OU filtering/targeting, or if policy applies to all users
- Update Group Policy documentation
