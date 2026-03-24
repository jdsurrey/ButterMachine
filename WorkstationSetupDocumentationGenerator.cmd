@echo off
setlocal enabledelayedexpansion
color 0A
title Workstation Setup Documentation Generator

cls
echo ========================================
echo Workstation Setup Documentation Generator
echo ========================================
echo.

REM Collect all inputs
set /p company_name="Enter Company Name: "
echo.

set /p workstation_type="Enter Workstation Type (Office/Operatory/Pharmacy/Plant/Safety/Other): "
echo.

set /p workstation_description="Enter Workstation Description/Details: "
echo.

set /p docking_station="Is a Docking Station required? (Yes/No): "
echo.

if /i "!docking_station!"=="Yes" (
    set /p docking_station_type="Enter Docking Station Type: "
    set /p docking_station_notes="Enter Docking Station Setup Notes: "
) else (
    set "docking_station_type=N/A"
    set "docking_station_notes=N/A"
)
echo.

REM Check if Dental OP
if /i "!workstation_type!"=="Operatory" (
    set /p dental_sensors="Enter Sensors/Cameras Connected (or N/A): "
    set /p dental_kb_link="Enter Link to Global KB for Sensor Installation: "
) else (
    set "dental_sensors=N/A"
    set "dental_kb_link=N/A"
)
echo.

set /p network_connectivity="Enter Internet Connection Type (Ethernet/Wi-Fi/Both): "
echo.

set /p network_vpnremote_access="Is VPN/Remote Access Required? (Yes/No): "
echo.

if /i "!network_vpnremote_access!"=="Yes" (
    set /p vpn_type="Enter VPN Type (ScreenConnect/ConnectWise/Other): "
    set /p vpn_kb_link="Enter Link to VPN Setup in HUDU (or N/A): "
) else (
    set "vpn_type=N/A"
    set "vpn_kb_link=N/A"
)
echo.

set /p network_notes="Enter Additional Network Notes: "
echo.

set /p operating_system="Enter Operating System (Windows 10/Windows 11/Other): "
echo.

set /p os_notes="Enter OS Compatibility Notes (or N/A): "
echo.

set /p mfa="Enter MFA Requirements (None/Required/Conditional): "
echo.

set /p productivity_suite="Enter Productivity Suite (Microsoft Office/Google Workspace/Other): "
echo.

set /p software_apps="Enter Required Software Applications (comma-separated): "
echo.

set /p software_links="Enter Software Installation Links/Notes: "
echo.

set /p software_training="Enter Training Materials/Knowledge Base Links: "
echo.

set /p software_support="Enter Software Support Contact Information: "
echo.

set /p email_client="Enter Email Client (Outlook/Gmail/Other): "
echo.

set /p email_setup_link="Enter Email Setup Instructions Link (or N/A): "
echo.

set /p browser_preference="Enter Browser Preference (Edge/Chrome/Firefox): "
echo.

set /p pdf_software="Enter PDF Reader (Adobe Reader/Adobe Acrobat/Foxit/Other): "
echo.

set /p user_training_notes="Enter User Training Notes: "
echo.

set /p technical_support_tips="Enter Technical Support Tips/Troubleshooting Guide: "
echo.

REM Output folder selection
cls
echo ========================================
echo Output Folder Selection
echo ========================================
echo.
echo 1. User Documents Folder (Default)
echo 2. Desktop
echo 3. Custom Folder
echo.
set /p folder_choice="Select output folder (1-3): "
echo.

if "%folder_choice%"=="1" (
    set "output_folder=%USERPROFILE%\Documents"
    set "folder_display=Documents Folder"
) else if "%folder_choice%"=="2" (
    set "output_folder=%USERPROFILE%\Desktop"
    set "folder_display=Desktop"
) else if "%folder_choice%"=="3" (
    set /p output_folder="Enter full folder path: "
    set "folder_display=!output_folder!"
    if not exist "!output_folder!" (
        mkdir "!output_folder!"
    )
) else (
    set "output_folder=%USERPROFILE%\Documents"
    set "folder_display=Documents Folder"
)

REM Create output files
set "output_docx=!output_folder!\%company_name%_%workstation_type%_Workstation_Setup.docx"
set "temp_dir=%temp%\docx_temp_%random%"

if not exist "!temp_dir!" mkdir "!temp_dir!"

cls
echo ========================================
echo Generating Document...
echo ========================================
echo.

REM Create professional document.xml content - ENHANCED WORKSTATION VERSION
(
echo ^<?xml version="1.0" encoding="UTF-8" standalone="yes"?^>
echo ^<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"^>
echo ^<w:body^>
echo ^<w:sectPr^>^<w:pgMar w:top="360" w:right="720" w:bottom="720" w:left="720"/^>^</w:sectPr^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="0" w:after="0"/^>^</w:pPr^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:jc w:val="left"/^>^<w:spacing w:before="0" w:after="20"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="48"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>%company_name%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:jc w:val="left"/^>^<w:spacing w:before="0" w:after="40"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^<w:color w:val="4472C4"/^>^</w:rPr^>^<w:t^>%workstation_type% Workstation Setup^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="0" w:after="60"/^>^<w:pBdr^>^<w:bottom w:val="single" w:sz="12" w:space="1" w:color="1F4E78"/^>^</w:pBdr^>^</w:pPr^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:sz w:val="18"/^>^<w:color w:val="595959"/^>^</w:rPr^>^<w:t^>Description: %workstation_description%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="40" w:after="60"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="26"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>1. Hardware^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Workstation Type:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %workstation_type%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Docking Station:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %docking_station%^</w:t^>^</w:r^>^</w:p^>
echo.
if /i "!docking_station!"=="Yes" (
    echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Docking Station Type:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %docking_station_type%^</w:t^>^</w:r^>^</w:p^>
    echo.
    echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="40"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Docking Station Setup Notes:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %docking_station_notes%^</w:t^>^</w:r^>^</w:p^>
)
echo.
if /i "!workstation_type!"=="Operatory" (
    echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Sensors/Intraoral Cameras:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %dental_sensors%^</w:t^>^</w:r^>^</w:p^>
    echo.
    echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="40"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="18"/^>^<w:color w:val="4472C4"/^>^</w:rPr^>^<w:t^>KB Link for Installation:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="18"/^>^</w:rPr^>^<w:t^>     %dental_kb_link%^</w:t^>^</w:r^>^</w:p^>
)
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="40" w:after="60"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="26"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>2. Network and Connectivity^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Internet Connection:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %network_connectivity%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>VPN/Remote Access Required:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %network_vpnremote_access%^</w:t^>^</w:r^>^</w:p^>
echo.
if /i "!network_vpnremote_access!"=="Yes" (
    echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>VPN Type:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %vpn_type%^</w:t^>^</w:r^>^</w:p^>
    echo.
    echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="18"/^>^<w:color w:val="4472C4"/^>^</w:rPr^>^<w:t^>VPN Setup Link:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="18"/^>^</w:rPr^>^<w:t^>     %vpn_kb_link%^</w:t^>^</w:r^>^</w:p^>
)
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="40"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Network Notes:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %network_notes%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="40" w:after="60"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="26"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>3. Operating System and Software^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Operating System:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %operating_system%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>OS Compatibility Notes:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %os_notes%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>MFA Requirements:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %mfa%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="22"/^>^<w:color w:val="4472C4"/^>^</w:rPr^>^<w:t^>Productivity Suite:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %productivity_suite%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="22"/^>^<w:color w:val="4472C4"/^>^</w:rPr^>^<w:t^>Required Software Applications:^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="10" w:after="20"/^>^<w:ind w:left="720"/^>^</w:pPr^>^<w:r^>^<w:sz w:val="20"/^>^<w:t^>%software_apps%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Installation Links/Notes:^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="10" w:after="20"/^>^<w:ind w:left="720"/^>^</w:pPr^>^<w:r^>^<w:sz w:val="20"/^>^<w:t^>%software_links%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Training Materials/KB Articles:^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="10" w:after="20"/^>^<w:ind w:left="720"/^>^</w:pPr^>^<w:r^>^<w:sz w:val="20"/^>^<w:t^>%software_training%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="40"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Software Support Contact:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %software_support%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="40" w:after="60"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="26"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>4. User Preferences and Customizations^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Email Client:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %email_client%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="18"/^>^<w:color w:val="4472C4"/^>^</w:rPr^>^<w:t^>Email Setup Instructions:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="18"/^>^</w:rPr^>^<w:t^>     %email_setup_link%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Browser Preference:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %browser_preference%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="40"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>PDF Reader:^</w:t^>^</w:r^>^<w:r^>^<w:rPr^>^<w:sz w:val="20"/^>^</w:rPr^>^<w:t^>     %pdf_software%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="40" w:after="60"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="26"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>5. User Training and Support^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>User Training Notes:^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="10" w:after="20"/^>^<w:ind w:left="720"/^>^</w:pPr^>^<w:r^>^<w:sz w:val="20"/^>^<w:t^>%user_training_notes%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="20" w:after="20"/^>^<w:ind w:left="360"/^>^</w:pPr^>^<w:r^>^<w:rPr^>^<w:b/^>^<w:sz w:val="20"/^>^<w:color w:val="1F4E78"/^>^</w:rPr^>^<w:t^>Technical Support Tips / Troubleshooting:^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^<w:p^>^<w:pPr^>^<w:spacing w:before="10" w:after="60"/^>^<w:ind w:left="720"/^>^</w:pPr^>^<w:r^>^<w:sz w:val="20"/^>^<w:t^>%technical_support_tips%^</w:t^>^</w:r^>^</w:p^>
echo.
echo ^</w:body^>
echo ^</w:document^>
) > "!temp_dir!\document.xml" 2>nul

if not exist "!temp_dir!\document.xml" (
    cls
    echo ERROR: Could not create document XML
    echo Please check your input for special characters
    echo.
    pause
    goto :eof
)

REM Create _rels/.rels
mkdir "!temp_dir!\_rels" 2>nul
(
echo ^<?xml version="1.0" encoding="UTF-8" standalone="yes"?^>
echo ^<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"^>
echo ^<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/^>
echo ^</Relationships^>
) > "!temp_dir!\_rels\.rels" 2>nul

REM Create word directory and _rels
mkdir "!temp_dir!\word" 2>nul
mkdir "!temp_dir!\word\_rels" 2>nul

REM Move document.xml to word folder
move "!temp_dir!\document.xml" "!temp_dir!\word\document.xml" >nul 2>&1

REM Create word/_rels/document.xml.rels
(
echo ^<?xml version="1.0" encoding="UTF-8" standalone="yes"?^>
echo ^<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"^>
echo ^</Relationships^>
) > "!temp_dir!\word\_rels\document.xml.rels" 2>nul

REM Create [Content_Types].xml
(
echo ^<?xml version="1.0" encoding="UTF-8" standalone="yes"?^>
echo ^<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"^>
echo ^<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/^>
echo ^<Default Extension="xml" ContentType="application/xml"/^>
echo ^<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/^>
echo ^</Types^>
) > "!temp_dir!\[Content_Types].xml" 2>nul

REM Use PowerShell to create ZIP (DOCX)
powershell -NoProfile -Command "Add-Type -AssemblyName 'System.IO.Compression.FileSystem'; [System.IO.Compression.ZipFile]::CreateFromDirectory('!temp_dir!', '!output_docx!', 'Optimal', $false)" 2>nul

if not exist "!output_docx!" (
    powershell -NoProfile -Command "Add-Type -AssemblyName 'System.IO.Compression.FileSystem'; [System.IO.Compression.ZipFile]::CreateFromDirectory('!temp_dir!', '!output_docx!', 'NoCompression', $false)" 2>nul
)

REM Clean up temp directory
rmdir /s /q "!temp_dir!" 2>nul

if exist "!output_docx!" (
    cls
    echo ========================================
    echo SUCCESS!
    echo ========================================
    echo.
    echo File created: %company_name%_%workstation_type%_Workstation_Setup.docx
    echo.
    echo Output Location: !folder_display!
    echo Full Path: !output_docx!
    echo.
    echo Document includes:
    echo  - Workstation type-specific setup instructions
    echo  - Hardware configuration details
    echo  - Network and connectivity requirements
    echo  - Operating system compatibility notes
    echo  - Software installation and support links
    echo  - User preferences and customizations
    echo  - Comprehensive training and support guidance
    echo.
) else (
    cls
    echo ========================================
    echo ERROR
    echo ========================================
    echo.
    echo Could not create the DOCX file.
    echo This may be due to:
    echo - PowerShell permissions
    echo - Special characters in your input
    echo - File path issues
    echo.
    echo Try using simpler text without special characters.
    echo.
)

pause