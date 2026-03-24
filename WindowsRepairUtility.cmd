@echo off
:: ================================================================
:: Windows System Repair & Image Health Utility
:: Requires: Administrator privileges
:: ================================================================

echo ================================================================
echo WINDOWS SYSTEM REPAIR UTILITY
echo ================================================================
echo.
echo ** Journey to Mordor **
echo **One does not simply repair Windows without a journey to Mordor!**
echo ** CRITICAL: Close all applications before proceeding **
echo ** Estimated time: 15-45 minutes depending on system state **
echo.
pause

:: Create log file on C:\
set LOGFILE=C:\WindowsRepair_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt
echo Windows Repair Log - %date% %time% > "%LOGFILE%"
echo ================================================================ >> "%LOGFILE%"

:: ================================================================
:: STEP 1: System File Checker (SFC)
:: ================================================================
echo.
echo ================================================================
echo                   LEAVING THE SHIRE
echo ================================================================
echo.
echo              ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
echo            ~  The Green Hill Country  ~
echo          ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
echo.
echo                    ___===___
echo                ___/         \___
echo            ___/   BAG END      \___
echo           /  ___________________   \
echo          /  /                   \   \
echo         /__/   [ ]         [ ]   \___\
echo         ^|  ^|                     ^|   ^|
echo         ^|  ^|    _____________    ^|   ^|
echo         ^|  ^|   ^|    ( )     ^|   ^|   ^|
echo         ^|__^|___^|_____^^^_____^|___^|___^|
echo            ^|                     ^|
echo         ___^|___               ___^|___
echo.
echo             .   *  .     *   .
echo          *    Hobbit Holes   *  .
echo           .  *   .    *   .    *
echo.
echo           o          o          o
echo          /^\        /^\        /^\
echo         / + \      / + \      / + \
echo           ^|          ^|          ^|
echo.
echo        Frodo      Sam       Merry
echo.
echo    "The road goes ever on and on..."
echo.
echo [Leaving the Shire] Running System File Checker...
echo [Leaving the Shire] Running System File Checker... >> "%LOGFILE%"
sfc /scannow >> "%LOGFILE%" 2>&1
echo.

:: ================================================================
:: STEP 2: DISM - Component Store Analysis
:: ================================================================
echo.
echo ================================================================
echo               JOURNEYING THROUGH BREE
echo ================================================================
echo.
echo          THE PRANCING PONY INN
echo.
echo              _______________
echo             /^|^|^|^|^|^|^|^|^|^|^|^|^|\
echo            /_^|^|^|^|^|^|^|^|^|^|^|^|^|_\
echo           ^|  ===============  ^|
echo           ^|  ^|^|  PRANCING ^|^|  ^|
echo           ^|  ^|^|    PONY   ^|^|  ^|
echo           ^|  ^|^|    * * *  ^|^|  ^|
echo      _____|__^|^|___________^|^|__|_____
echo     ^|                                 ^|
echo     ^|  [ ]  [ ]          [ ]  [ ]    ^|
echo     ^|                                 ^|
echo     ^|  ^^^  FOOD  ^^^  ALE  ^^^  ROOMS  ^^^  ^|
echo     ^|_________________________________^|
echo     ^|    _____________________        ^|
echo     ^|   ^|         ___         ^|       ^|
echo     ^|   ^|        ^|   ^|        ^|       ^|
echo     ^|___^|________^|___^|________^|_______^|
echo         ^|^|                         ^|^|
echo         ^|^|    WELCOME TRAVELERS    ^|^|
echo.
echo            o          o
echo           /^\        /^\
echo          / + \      / + \
echo            ^|          ^|
echo.
echo         "A pint and a story..."
echo.
echo [Journeying through Bree] Analyzing component store...
echo [Journeying through Bree] Analyzing component store... >> "%LOGFILE%"
DISM.exe /Online /Cleanup-Image /AnalyzeComponentStore >> "%LOGFILE%" 2>&1
echo.

:: ================================================================
:: STEP 3: DISM - Scan Health
:: ================================================================
echo.
echo ================================================================
echo              CROSSING INTO RIVENDELL
echo ================================================================
echo.
echo        IMLADRIS - THE LAST HOMELY HOUSE
echo.
echo               *    .      *     .    *
echo          *      .    ELVEN   .    *     .
echo       .    *   .   SANCTUARY  .  *   .
echo            *    .      *     .    *
echo.
echo              /\                    /\
echo             /**\      ________    /**\
echo            /****\    /        \  /****\
echo           /  /\  \  /  HOUSE   \/  /\  \
echo          /  /  \  \/   OF      /\ /  \  \
echo         /  / /\ \ \   ELROND  /  / /\ \  \
echo        /__/  ^^  \__\ _______ / _/  ^^  \__\
echo        ^|^|^|    *   ^|^|^|^|      ^|^|^|^|   *    ^|^|^|
echo        ^|^|^|  .   * ^|^|^|^| HALL ^|^|^|^| *   .  ^|^|^|
echo        ^|^|^|________^|^|^|^|______^|^|^|^|________^|^|^|
echo.
echo         ~  ~  ~  ~ ~ ~ ~ ~ ~ ~  ~  ~  ~
echo       ~   River Bruinen (Loudwater)   ~
echo         ~  ~  ~  ~ ~ ~ ~ ~ ~ ~  ~  ~  ~
echo.
echo           o          o          o
echo          /^\        /^\        /^\
echo         / + \      / + \      / + \
echo           ^|          ^|          ^|
echo.
echo    "Wisdom and healing in the valley..."
echo.
echo [Crossing into Rivendell] Scanning image health (this may take several minutes)...
echo [Crossing into Rivendell] Scanning image health... >> "%LOGFILE%"
DISM.exe /Online /Cleanup-Image /ScanHealth >> "%LOGFILE%" 2>&1
echo.

:: ================================================================
:: STEP 4: DISM - Restore Health
:: ================================================================
echo.
echo ================================================================
echo               PASSING THROUGH MORIA
echo ================================================================
echo.
echo      THE MINES OF MORIA - KHAZAD-DUM
echo           "Speak friend and enter"
echo.
echo    ___________________________________________
echo   ^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|^|
echo   ^|^|    _____     _____     _____     ___  ^|^|
echo   ^|^|   ^|     ^|   ^|     ^|   ^|     ^|   ^|   ^| ^|^|
echo   ^|^|   ^|  D  ^|   ^|  W  ^|   ^|  A  ^|   ^| R | ^|^|
echo   ^|^|   ^|  U  ^|   ^|  A  ^|   ^|  R  ^|   ^| F | ^|^|
echo   ^|^|   ^|  R  ^|   ^|  R  ^|   ^|  V  ^|   ^|   ^| ^|^|
echo   ^|^|   ^|  I  ^|   ^|  F  ^|   ^|  E  ^|   ^| H | ^|^|
echo   ^|^|   ^|  N  ^|   ^|     ^|   ^|  S  ^|   ^| A | ^|^|
echo   ^|^|   ^|_____^|   ^|_____^|   ^|_____^|   ^|___^| ^|^|
echo   ^|^|                                       ^|^|
echo   ^|^|   THE GREAT HALLS OF THE DWARVES    ^|^|
echo   ^|^|                                       ^|^|
echo   ^|^|_____________________________________ ^|^|
echo   ^|\___________  THE   DEEP  ____________/^|
echo    \__________   DARKNESS    ___________/ ^|
echo       \________   AWAKENS   _________/    ^|
echo         \_____________________/
echo.
echo             ^|^|                    ^|^|
echo             ^|^|   DRUMS IN THE    ^|^|
echo             ^|^|      DEEP         ^|^|
echo             ^|^|                    ^|^|
echo.
echo           o          o
echo          /^\        /^\
echo         / + \      / + \
echo           ^|          ^|
echo.
echo         "YOU SHALL NOT PASS!"
echo      (This may take 10-20 minutes...)
echo.
echo [Passing through Moria] Restoring image health (this may take 10-20 minutes)...
echo [Passing through Moria] Restoring image health... >> "%LOGFILE%"
DISM.exe /Online /Cleanup-Image /RestoreHealth >> "%LOGFILE%" 2>&1
echo.

:: ================================================================
:: STEP 5: DISM - Component Cleanup
:: ================================================================
echo.
echo ================================================================
echo              RESTING IN LOTHLORIEN
echo ================================================================
echo.
echo     LOTHLORIEN - THE GOLDEN WOOD OF GALADRIEL
echo.
echo         *  .    *    .  *    .    *  .    *
echo      *    . THE MALLORN TREES  .    *   .
echo    .   *   .  *  SHIMMER  *  .  *   .  *
echo      *  . WITH GOLDEN LIGHT  .  *  .   *
echo         *  .    *    .  *    .    *  .    *
echo.
echo               /\          /\         /\
echo          *   /**\    *   /**\   .   /**\  *
echo        .    /****\      /****\     /****\
echo            /  /\  \    /  /\  \   /  /\  \
echo       *   /  /**\  \  /  /**\  \ /  /**\  \   *
echo      .   /  / ** \  \/  / ** \ X  / ** \  \
echo         /__/  **  \__\__/  **  X _/  **  \__\
echo     *   ^|^|^|   **   ^|^|^|^|^|   ** ^|^|^|   **   ^|^|^| *
echo       . ^|^|^|  ****  ^|^|^|^|^| **** ^|^|^| ****  ^|^|^|  .
echo    *    ^|^|^| ****** ^|^|^|^|^|******^|^|^|****** ^|^|^|   *
echo      .  ^|^|^|********^|^|^|^|^|******^|^|^|*******^|^|^|  .
echo.
echo            ~  ~  ~  ~  ~  ~  ~  ~  ~
echo          ~   The Silverlode River   ~
echo            ~  ~  ~  ~  ~  ~  ~  ~  ~
echo.
echo           o          o
echo          /^\        /^\
echo         / + \      / + \
echo           ^|          ^|
echo.
echo      "Here time does not flow..."
echo   "Rest and receive Galadriel's gifts"
echo.
echo [Resting in Lothlorien] Cleaning up component store...
echo [Resting in Lothlorien] Cleaning up component store... >> "%LOGFILE%"
DISM.exe /Online /Cleanup-Image /StartComponentCleanup >> "%LOGFILE%" 2>&1
echo.

:: ================================================================
:: STEP 6: DISM - Reset Base (frees disk space)
:: ================================================================
echo.
echo ================================================================
echo           BREAKING OF THE FELLOWSHIP
echo ================================================================
echo.
echo           AMON HEN - THE HILL OF SIGHT
echo         "The Fellowship must divide..."
echo.
echo                 .     .     .
echo                  \   ^|   /
echo                   \  ^|  /
echo               .--.  ^|  .--.
echo              /    \ ^| /    \
echo             /  WE  \^|/ MUST \
echo            (   PART WAYS    )
echo             \      /^\      /
echo              \    / ^| \    /
echo               `--'  ^|  `--'
echo                  /  ^|  \
echo                 /   ^|   \
echo                '    '    `
echo.
echo         o       ~~~X~~~       o
echo        /^\     ~  /^\  ~     /^\
echo       / + \   ~  / + \  ~   / + \
echo         ^|    ~ ~ ~ ^| ~ ~ ~   ^|
echo              ~      ^|      ~
echo            ~        ^|        ~
echo          ~    PATHS DIVIDE    ~
echo.
echo      Frodo and Sam          Aragorn
echo     (Towards Mordor)    (To Gondor)
echo.
echo        "I would have followed you..."
echo        "My brother, my captain..."
echo.
echo [Breaking of the Fellowship] Resetting component base (frees disk space)...
echo [Breaking of the Fellowship] Resetting component base... >> "%LOGFILE%"
DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase >> "%LOGFILE%" 2>&1
echo.

:: ================================================================
:: STEP 7: Final SFC Scan (verify repairs)
:: ================================================================
echo.
echo ================================================================
echo             APPROACHING MOUNT DOOM
echo ================================================================
echo.
echo           ORODRUIN - THE MOUNTAIN OF FIRE
echo.
echo                  .  ^^  .    ^^   .
echo               .   ^^  .  ^^  .  ^^   .
echo             ^^   .  ^^    ^^  .   ^^   ^^
echo           ^^  .    ^^  .    ^^  .    ^^  .
echo          _....._  ___........___  _....._
echo         / ^^  . \/  ^^      ^^  \/  . ^^ \
echo        / .   ^^   ^^  .  ^^  .  ^^   ^^ . \
echo       /   ^^   .    ^^    ^^    .   ^^   ^\
echo      /  .   ^^   .    ^^  ^^    .  ^^  .  ^\
echo     ^|    ^^    .   ^^    ^^   ^^  .    ^^  ^|
echo     ^|  .    ^^   .    THE EYE   ^^   .  ^^ ^|
echo     ^|   ^^    .   ^^     OF     .  ^^   .  ^|
echo     ^|     .    ^^   . SAURON ^^   .   ^^   ^|
echo     ^|  ^^   .    ^^    (o)    .  ^^  .   ^^ ^|
echo     ^|    .   ^^    . ^^  ^^ .   ^^   .   ^^ ^|
echo      \  ^^   .  ^^  ^^^  ^^^  ^^  .  ^^   . /
echo       \   .  ^^   .  ^^  ^^  .  ^^   .  ^^ /
echo        \  ^^   . ^^   .    .  ^^  . ^^   ./
echo         \___^^____.___^^____^^___.____^^___/
echo            ^|^|                       ^|^|
echo            ^|^|   SAMMATH NAUR       ^|^|
echo            ^|^|   (Chambers of       ^|^|
echo            ^|^|      Fire)           ^|^|
echo            ^|^|                       ^|^|
echo.
echo                o
echo               /^\
echo              / + \
echo                ^|
echo.
echo            "The final test..."
echo           "I can see the fires..."
echo.
echo [Approaching Mount Doom] Running final verification scan...
echo [Approaching Mount Doom] Running final verification scan... >> "%LOGFILE%"
sfc /scannow >> "%LOGFILE%" 2>&1
echo.

:: ================================================================
:: Additional Maintenance Operations
:: ================================================================
echo.
echo ================================================================
echo          CASTING THE RING INTO THE FIRE
echo ================================================================
echo.
echo        THE CRACKS OF DOOM - THE RING IS DESTROYED
echo.
echo              ,,,,,,,,,,,,,,,,,,
echo           ,,,;;;;;;;;;;;;;;;;;;;;,,,
echo         ,,;;;;;;;;;;;;;;;;;;;;;;;;;;,,
echo        ,;;;;;;;;;;;;  ;;;;;;;;;;;;;;,
echo       ,;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;,
echo      ,;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;,
echo      ;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;
echo     ,;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;,
echo     ;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;
echo     ;;;;;;;;;;;;;;;;();;;;;;;;;;;;;;;;;;
echo     ;;;;;;;;;;;;;;;(  );;;;;;;;;;;;;;;;;
echo     ;;;;;;;;;;;;;;;(  );;;;;;;;;;;;;;;;;
echo     ;;;;;;;;;;;;;;;(  );;;;;;;;;;;;;;;;;
echo     ;;;;;;;;;;;;;;;(  );;;;;;;;;;;;;;;;;
echo     `;;;;;;;;;;;;;;;();;;;;;;;;;;;;;;;;;'
echo      `;;;;;;;;;;;;  . ;;;;;;;;;;;;;;;;'
echo       `;;;;;;;;;; .   ;;;;;;;;;;;;;'
echo        `;;;;;;;;  .    ;;;;;;;;;;;'
echo          `;;;;;  .      ;;;;;;;;'
echo            `;;  .        ;;;;;'
echo              ` .          ;'
echo                .
echo             THE RING
echo.
echo               o     \O/
echo              /^\     ^|
echo             / + \   /^\
echo               ^|
echo.
echo          "Into the fire!"
echo       "IT IS DONE!"
echo.
echo [Casting the Ring into the Fire] Running disk cleanup operations...
echo [Casting the Ring into the Fire] Running disk cleanup operations... >> "%LOGFILE%"

:: Clear temp files
echo - Clearing temp files...
del /q /f /s %TEMP%\* >> "%LOGFILE%" 2>&1
del /q /f /s C:\Windows\Temp\* >> "%LOGFILE%" 2>&1

:: Check disk health
echo - Checking disk for errors...
echo Y | chkdsk C: /F /R >> "%LOGFILE%" 2>&1

:: ================================================================
:: Completion
:: ================================================================
echo.
echo ================================================================
echo         THE RING HAS BEEN DESTROYED!
echo              SAURON IS DEFEATED!
echo ================================================================
echo.
echo                 _______________
echo                /               \
echo               /     VICTORY     \
echo              /                   \
echo             ^|    ___________     ^|
echo             ^|   ^|           ^|    ^|
echo             ^|   ^|  MIDDLE   ^|    ^|
echo             ^|   ^|   EARTH   ^|    ^|
echo             ^|   ^|    IS     ^|    ^|
echo             ^|   ^|   SAVED   ^|    ^|
echo             ^|   ^|___________^|    ^|
echo              \                   /
echo               \  ***********   /
echo                \_____________/
echo.
echo           \O/       \O/       \O/
echo            ^|         ^|         ^|
echo           /^\       /^\       /^\
echo.
echo         Frodo     Sam      Gandalf
echo.
echo              ______________
echo             /              \
echo            /  THE SHIRE     \
echo           /    AWAITS        \
echo          /      HOME          \
echo         /______________________\
echo.
echo      "Well, I'm back." - Sam
echo.
echo ================================================================
echo THE RING HAS BEEN DESTROYED - REPAIRS COMPLETE
echo ================================================================
echo.
echo Log file saved to: %LOGFILE%
echo.
echo ** NEXT STEPS:
echo 1. Review the log file for any errors
echo 2. Restart your computer to complete repairs
echo 3. If issues persist, check Event Viewer for additional details
echo.
echo ** IMPORTANT: A restart is required to finalize changes
echo.
pause

:: Offer restart option
echo.
set /p RESTART="Restart computer now? (Y/N): "
if /i "%RESTART%"=="y" shutdown /r /t 30 /c "System restarting to complete Windows repairs. Save your work."

pause
exit