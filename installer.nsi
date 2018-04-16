Unicode true
CRCCheck force
SetCompress auto
SetCompressionLevel 9
SetCompressor /SOLID lzma
SetCompressorDictSize 64


; Define your application name
!define APPNAME "Mod Organizer"
!define BASE "E:\MO2-Release"

!define MAJOR_DOWNLOAD_BASE "https://github.com/Modorganizer2/modorganizer/releases/download/v2.1.0/"
!define DOWNLOAD_BASE "https://github.com/Modorganizer2/modorganizer/releases/download/v2.1.2/"

!include 'LogicLib.nsh'
!include 'Sections.nsh'
!include 'x64.nsh'
!include 'WordFunc.nsh'

!makensis '-DBASE=${BASE} extractfileversion.nsi'

!system "ExtractVersionInfo.exe"
!include "App-Version.txt"



!define MULTIUSER_EXECUTIONLEVEL Highest
!define MULTIUSER_USE_PROGRAMFILES64
!define MULTIUSER_MUI
!define MULTIUSER_INSTALLMODE_COMMANDLINE
!define MULTIUSER_INSTALLMODE_INSTDIR ModOrganizer
!include "MultiUser.nsh"
!include "MUI2.nsh"

${UnStrLoc}


!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\ModOrganizer.exe"

!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of Mod Organizer ${Version}.$\r$\n$\r$\n\
                            IMPORTANT!$\r$\n\
                            You can install over an existing installation of Mod Organizer to update/repair it.$\r$\n\
                            This deletes all files that were ever installed by the installer but no data and no custom plugins.$\r$\n$\r$\n\
                            Click Next to continue."

!define MUI_COMPONENTSPAGE_SMALLDESC

!define MUI_ICON "mo_icon.ico"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${BASE}\install\licenses\GPL-v3.0.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL


Function .onInit
  !insertmacro MULTIUSER_INIT
  ${IfNot} ${RunningX64}
  MessageBox MB_OK "Mod Organizer 2 only supports 64-bit systems"
  Abort
  ${EndIf}
  SetRegView 64
FunctionEnd

Function un.onInit
  !insertmacro MULTIUSER_UNINIT
FunctionEnd


Function ConnectInternet
  Push $R0
    ClearErrors
    Dialer::AttemptConnect
    IfErrors noie3

    Pop $R0
    StrCmp $R0 "online" connected
      MessageBox MB_OK|MB_ICONSTOP "Cannot connect to the internet."
      Quit

    noie3:

    ; IE3 not installed
    MessageBox MB_OK|MB_ICONINFORMATION "Please connect to the internet now."

    connected:

  Pop $R0
FunctionEnd


!macro CleanUp un
  Function ${un}CleanUp
    Delete "$INSTDIR\ModOrganizer.exe"
    Delete "$INSTDIR\helper.exe"
    Delete "$INSTDIR\usvfs_x64.dll"
    Delete "$INSTDIR\usvfs_x86.dll"
    Delete "$INSTDIR\usvfs_proxy_x86.exe"
    Delete "$INSTDIR\usvfs_proxy_x64.exe"
    Delete "$INSTDIR\nxmhandler.exe"
    Delete "$INSTDIR\uibase.dll"
    Delete "$INSTDIR\ssleay32.dll"
	  Delete "$INSTDIR\QtWebEngineProcess.exe"
	  Delete "$INSTDIR\libeay32.dll"
	  Delete "$INSTDIR\boost_python-vc141-mt-x64-?_??.dll"
    Delete "$INSTDIR\loot\lootcli.exe"
    Delete "$INSTDIR\loot\loot_api.dll"
    Delete "$INSTDIR\platforms\qwindows.dll"
    Delete "$INSTDIR\styles\qwindowsvistastyle.dll"
	  Delete "$INSTDIR\QtQuick.2\*"
    Delete "$INSTDIR\NCC\*"
    Delete "$INSTDIR\translations\*"
    Delete "$INSTDIR\plugins\bsa_extractor.dll"
    Delete "$INSTDIR\plugins\installer_bundle.dll"
    Delete "$INSTDIR\plugins\diagnose_basic.dll"
    Delete "$INSTDIR\plugins\installer_manual.dll"
    Delete "$INSTDIR\plugins\installer_quick.dll"
    Delete "$INSTDIR\plugins\installer_BAIN.dll"
    Delete "$INSTDIR\plugins\installer_fomod.dll"
    Delete "$INSTDIR\plugins\installer_NCC.dll"
    Delete "$INSTDIR\plugins\plugin_python.dll"
    Delete "$INSTDIR\plugins\inibakery.dll"
    Delete "$INSTDIR\plugins\ini_editor.dll"
    Delete "$INSTDIR\plugins\check_FNIS.dll"
    Delete "$INSTDIR\plugins\preview_base.dll"
    Delete "$INSTDIR\plugins\game_oblivion.dll"
    Delete "$INSTDIR\plugins\game_morrowind.dll"
    Delete "$INSTDIR\plugins\game_fallout3.dll"
    Delete "$INSTDIR\plugins\game_fallout4.dll"
    Delete "$INSTDIR\plugins\game_fallout4vr.dll"
    Delete "$INSTDIR\plugins\game_falloutNV.dll"
    Delete "$INSTDIR\plugins\game_skyrim.dll"
    Delete "$INSTDIR\plugins\game_skyrimvr.dll"
	  Delete "$INSTDIR\plugins\game_skyrimse.dll"
    Delete "$INSTDIR\plugins\game_ttw.dll"
    Delete "$INSTDIR\plugins\pyCfg.py"
    Delete "$INSTDIR\plugins\data\pythonrunner.dll"
    Delete "$INSTDIR\plugins\data\sip.pyd"
    Delete "$INSTDIR\plugins\data\pyCfg*.py"
    Delete "$INSTDIR\plugins\data\settings.json"
  FunctionEnd
!macroend
!insertmacro CleanUp ""
!insertmacro CleanUp "un."

; Main Install settings
Name "${APPNAME} ${Version}"
;InstallDir "$PROGRAMFILES\Mod Organizer"
;InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "${APPNAME}-${Version}.exe"


Section ""
    Call ConnectInternet
SectionEnd


Section "!Mod Organizer" Section1

    ; Set Section properties
    SectionIn RO

    Call CleanUp

    ; Set Section Files and Shortcuts
    SetOutPath "$INSTDIR\"
    File "${BASE}\install\bin\ModOrganizer.exe"
    File "${BASE}\install\bin\helper.exe"
    File "${BASE}\install\bin\usvfs_x64.dll"
    File "${BASE}\install\bin\usvfs_x86.dll"
    File "${BASE}\install\bin\usvfs_proxy_x86.exe"
    File "${BASE}\install\bin\usvfs_proxy_x64.exe"
    File "${BASE}\install\bin\nxmhandler.exe"
    File "${BASE}\install\bin\uibase.dll"
	File "${BASE}\install\bin\QtWebEngineProcess.exe"
	File "${BASE}\install\bin\libeay32.dll"
	File "${BASE}\install\bin\ssleay32.dll"
	File "${BASE}\install\bin\boost_python-vc141-mt-x64-?_??.dll"
    SetOutPath "$INSTDIR\loot\"
    File "${BASE}\install\bin\loot\lootcli.exe"
    File "${BASE}\install\bin\loot\loot_api.dll"
    SetOutPath "$INSTDIR\plugins\"
    File "${BASE}\install\bin\plugins\installer_bundle.dll"
    File "${BASE}\install\bin\plugins\diagnose_basic.dll"
	File "${BASE}\install\bin\plugins\bsa_extractor.dll"
	File "${BASE}\install\bin\plugins\inibakery.dll"
    CreateDirectory "$INSTDIR\logs"
    SetOutPath "$INSTDIR\licenses\"
    File "${BASE}\install\licenses\*.txt"
    SetOutPath "$INSTDIR\platforms\"
    File "${BASE}\install\bin\platforms\qwindows.dll"
	SetOutPath "$INSTDIR\QtQuick.2"
    File "${BASE}\install\bin\QtQuick.2\qtquick2plugin.dll"
	File "${BASE}\install\bin\QtQuick.2\qmldir"
	File "${BASE}\install\bin\QtQuick.2\plugins.qmltypes"
    SetOutPath "$INSTDIR\DLLs\"
    File "${BASE}\install\bin\DLLs\7z.dll"
    File "${BASE}\install\bin\DLLs\archive.dll"
    File "${BASE}\install\bin\DLLs\libeay32.dll"
    File "${BASE}\install\bin\DLLs\ssleay32.dll"
	File "${BASE}\install\bin\DLLs\liblz4.dll"
	SetOutPath "$INSTDIR\resources\"
	File "${BASE}\install\bin\resources\icudtl.dat"
	File "${BASE}\install\bin\resources\qtwebengine_devtools_resources.pak"
	File "${BASE}\install\bin\resources\qtwebengine_resources.pak"
	File "${BASE}\install\bin\resources\qtwebengine_resources_100p.pak"
	File "${BASE}\install\bin\resources\qtwebengine_resources_200p.pak"
	SetOutPath "$INSTDIR\styles\"
	File "${BASE}\install\bin\styles\qwindowsvistastyle.dll"

    ReadRegStr $2 HKLM "SOFTWARE\Microsoft\DevDiv\vc\Servicing\14.0\RuntimeMinimum" "Version"
	ReadRegStr $3 HKLM "SOFTWARE\WOW6432Node\Microsoft\DevDiv\vc\Servicing\14.0\RuntimeMinimum" "Installed"
    ${VersionCompare} $2 "14.12.0" $R0
    ${If} $R0 == "2"
	${AndIf} $3 != "1"
;    IntCmp $1 1 vcredist_installed
        StrCpy $2 "$INSTDIR\VC_redist.x64.exe"
        inetc::get /CAPTION "Microsoft Visual C++ Runtime" "${MAJOR_DOWNLOAD_BASE}/VC_redist.x64.exe" "$2"
        Pop $0

        StrCmp $0 OK success
            SetDetailsView show
            DetailPrint "download failed: $0"
            Abort
        success:
            Exec "$INSTDIR\VC_redist.x64.exe /install /passive /norestart"
            Delete "$INSTDIR\VC_redist.x64.exe"
   ${EndIf}

    ReadRegStr $2 HKLM "SOFTWARE\WOW6432Node\Microsoft\DevDiv\vc\Servicing\14.0\RuntimeMinimum" "Version"
	ReadRegStr $3 HKLM "SOFTWARE\WOW6432Node\Microsoft\DevDiv\vc\Servicing\14.0\RuntimeMinimum" "Installed"
	${VersionCompare} $2 "14.12.0" $R0
    ${If} $R0 == "2"
	${AndIf} $3 != "1"
;    IntCmp $1 1 vcredist_installed
        StrCpy $2 "$INSTDIR\VC_redist.x86.exe"
        inetc::get /CAPTION "Microsoft Visual C++ Runtime" "${MAJOR_DOWNLOAD_BASE}/VC_redist.x86.exe" "$2"
        Pop $0

        StrCmp $0 OK success1
            SetDetailsView show
            DetailPrint "download failed: $0"
            Abort
        success1:
            Exec "$INSTDIR\vcredist.x86.exe /install /passive /norestart"
            Delete "$INSTDIR\VC_redist.x86.exe"
   ${EndIf}



SectionEnd

Section "Qt DLLs" Section2
    SetOutPath "$INSTDIR\dlls\"
    StrCpy $2 "$INSTDIR\qt.7z"
    inetc::get /CAPTION "Qt" "${MAJOR_DOWNLOAD_BASE}/Qt5.10.0.7z" "$2"
    Pop $0

    StrCmp $0 OK success
        SetDetailsView show
        DetailPrint "download failed: $0"
        Abort
    success:
        Nsis7z::ExtractWithDetails "$INSTDIR\qt.7z" "Installing %s..."
        Delete "$INSTDIR\qt.7z"

    File "${BASE}\install\bin\DLLs\dlls.manifest"
SectionEnd


SectionGroup "Plugins" PluginsGroup
    Section "Manual Installer" PluginsInstallerManual
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\installer_manual.dll"
    SectionEnd
    Section "Quick Installer" PluginsInstallerQuick
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\installer_quick.dll"
    SectionEnd
    Section "BAIN Installer" PluginsInstallerBAIN
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\installer_BAIN.dll"
    SectionEnd
    Section "FOMOD Installer" PluginsInstallerFOMOD
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\installer_fomod.dll"
    SectionEnd
    Section "NCC Installer" PluginsInstallerNCC
        SetOutPath "$INSTDIR\"
        StrCpy $2 "$INSTDIR\ncc.7z"
        inetc::get /CAPTION "NCC" "${DOWNLOAD_BASE}/ncc.7z" "$2"
        Pop $0

        StrCmp $0 OK success
            SetDetailsView show
            DetailPrint "download failed: $0"
            Abort
        success:
            Nsis7z::ExtractWithDetails "$INSTDIR\ncc.7z" "Installing %s..."
            Delete "$INSTDIR\ncc.7z"

    SectionEnd
    Section "Python Support" PluginPython
        SetOutPath "$INSTDIR\"
        StrCpy $2 "$INSTDIR\python.7z"
        inetc::get /CAPTION "Python" "${DOWNLOAD_BASE}/python.7z" "$2"
        Pop $0

        StrCmp $0 OK success
            SetDetailsView show
            DetailPrint "download failed: $0"
            Abort
        success:
            Nsis7z::ExtractWithDetails "$INSTDIR\python.7z" "Installing %s..."
            Delete "$INSTDIR\python.7z"
    SectionEnd
    Section "Legacy ini editor" PluginIniEditor
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\inieditor.dll"
    SectionEnd
    Section "FNIS Checker" PluginFNIS
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\check_fnis.dll"
    SectionEnd
    Section "Configurator" PluginConfigurator
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\pyCfg.py"
        SetOutPath "$INSTDIR\plugins\data\"
        File "${BASE}\install\bin\plugins\data\pyCfg*.py"
        File "${BASE}\install\bin\plugins\data\settings.json"
    SectionEnd
    Section "File Preview" PluginFilePreview
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\preview_base.dll"
    SectionEnd
    Section "Oblivion Support" PluginGameOblivion
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_oblivion.dll"
    SectionEnd
    Section "Morrowind Support" PluginGameMorrowind
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_morrowind.dll"
    SectionEnd
    Section "Fallout 3 Support" PluginGameFallout3
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_fallout3.dll"
    SectionEnd
    Section "TTW Support" PluginGamettw
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_ttw.dll"
    SectionEnd
    Section "Fallout 4 Support" PluginGameFallout4
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_fallout4.dll"
    SectionEnd
    Section "Fallout 4 VR Support" PluginGameFallout4vr
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_fallout4vr.dll"
    SectionEnd
    Section "New Vegas Support" PluginGameNewVegas
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_falloutNV.dll"
    SectionEnd
    Section "Skyrim Support" PluginGameSkyrim
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_skyrim.dll"
    SectionEnd
    Section "SkyrimVR Support" PluginGameSkyrimvr
        SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_skyrimvr.dll"
    SectionEnd
	Section "Skyrimse Support" PluginGameSkyrimse
	    SetOutPath "$INSTDIR\plugins\"
        File "${BASE}\install\bin\plugins\game_skyrimse.dll"
    SectionEnd
SectionGroupEnd

Section "Translations" Section5
    SetOutPath "$INSTDIR\"
    StrCpy $2 "$INSTDIR\translations.7z"
    inetc::get /CAPTION "Translations" "${DOWNLOAD_BASE}/translations.7z" "$2"
    Pop $0

    StrCmp $0 OK success
        SetDetailsView show
        DetailPrint "download failed: $0"
        Abort
    success:
        Nsis7z::ExtractWithDetails "$INSTDIR\translations.7z" "Installing %s..."
        Delete "$INSTDIR\translations.7z"
SectionEnd

Section "Tutorials" Section6
    SetOutPath "$INSTDIR\tutorials\"
    File "${BASE}\install\bin\tutorials\*.js"
    File "${BASE}\install\bin\tutorials\*.qml"
SectionEnd

Section "Stylesheets" Section7
    SetOverwrite on

    SetOutPath "$INSTDIR\stylesheets\"
    File "${BASE}\install\bin\stylesheets\dark.qss"
    File "${BASE}\install\bin\stylesheets\dracula.qss"
SectionEnd

Section /o "Handle Nexus Links" Section8
    WriteRegStr HKCU "Software\Classes\nxm\shell\open\command" "" '$INSTDIR\nxmhandler.exe "%1"'
SectionEnd

Section /o "Startmenu Shortcut" Section9
    CreateDirectory "$SMPROGRAMS\Mod Organizer"
    CreateShortCut "$SMPROGRAMS\Mod Organizer\Mod Organizer.lnk" "$INSTDIR\ModOrganizer.exe"
    CreateShortCut "$SMPROGRAMS\Mod Organizer\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section -FinishSection
;    WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
;    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
;    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$INSTDIR\uninstall.exe"
    WriteUninstaller "$INSTDIR\uninstall.exe"
    ; set path to instdir because this will be the cwd if the user chooses to run MO from the installer (seriously nsis???)
    SetOutPath "$INSTDIR\"
SectionEnd

Function .onSelChange
${If} ${SectionIsSelected} ${PluginPython}
    !insertmacro ClearSectionFlag ${PluginConfigurator} ${SF_RO}
${Else}
    !insertmacro SetSectionFlag ${PluginConfigurator} ${SF_RO}
    !insertmacro UnSelectSection ${PluginConfigurator}
${EndIf}
FunctionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Section1} "Core Application"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section2} "Qt DLLs version 5.10.0. These are REQUIRED for Mod Organizer to run."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginsInstallerNCC} "NCC is required to install some mods. It depends on the Microsoft .Net Framework."
    !insertmacro MUI_DESCRIPTION_TEXT ${Section5} "(Partial) translations of the Mod Organizer Interface to the various languages."
    !insertmacro MUI_DESCRIPTION_TEXT ${Section6} "Tutorials demonstrating basic usage inside the UI"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section7} "Additional themes for Mod Organizer"
    !insertmacro MUI_DESCRIPTION_TEXT ${Section8} "Have MO handle $\"Download (NMM)$\" links on Nexus. Can be changed after installation."
    !insertmacro MUI_DESCRIPTION_TEXT ${Section9} "Creates a starmenu shortcut for Mod Organizer and its uninstaller."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginsInstallerManual} "Fallback installer where custom adjustments during installation are necessary"
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginsInstallerQuick} "Installer for well structured archives without guided installer."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginsInstallerBAIN} "Installer for BAIN (Wrye Bash style) archives."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginsInstallerFOMOD} "Installer for xml-based FOMOD (FOMM/NMM style) archives."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginsGroup} "Plugins extend MOs functionality. Disable only if you know what you're doing."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginPython} "This plugin itself doesn't provide any functionality but it's required for some other plugins to work."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginFNIS} "Checks whether FNIS needs to be run every time you start the game. Doesn't hurt, even if you don't use FNIS."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginIniEditor} "Simple text editor for the game ini files."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginConfigurator} "More sophisticated ini editor. Requires the python plugin."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginFilePreview} "Provides File Preview capabilities for $\"simple$\" file types (images, text files)."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameOblivion} "Support for Oblivion."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameMorrowind} "Support for Morrowind."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameFallout3} "Support for Fallout 3."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGamettw} "Support for TTW."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameFallout4} "Support for Fallout 4."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameFallout4vr} "Support for Fallout 4 VR."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameNewVegas} "Support for Fallout New Vegas."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameSkyrim} "Support for Skyrim."
    !insertmacro MUI_DESCRIPTION_TEXT ${PluginGameSkyrimvr} "Support for Skyrim VR."
	!insertmacro MUI_DESCRIPTION_TEXT ${PluginGameSkyrimse} "Support for SkyrimSE."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall

    ;Remove from registry...
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
    DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

    ; Delete self
    Delete "$INSTDIR\uninstall.exe"

    ; Delete Shortcuts
    Delete "$DESKTOP\Mod Organizer.lnk"
    Delete "$SMPROGRAMS\Mod Organizer\Mod Organizer.lnk"
    Delete "$SMPROGRAMS\Mod Organizer\Uninstall.lnk"

    Call un.CleanUp

    ; Clean up cache of integrated browser
    RMDir /r "$INSTDIR\webcache"

    ; Clean up generated logs and dumps
    Delete "$INSTDIR\logs\*"
    Delete "$INSTDIR\ModOrganizer.exe.dmp"
    Delete "$INSTDIR\usvfs.dll.dmp"

    ; Clean up qt dll option
    Delete "$INSTDIR\DLLs\dlls.manifest"

	; Clean up License
    Delete "$INSTDIR\licenses\*"

	; Clean up DLL option
	Delete "$INSTDIR\DLLs\imageformats\*"
    Delete "$INSTDIR\DLLs\*"

    ; Clean up stylesheet option
    Delete "$INSTDIR\stylesheets\*.qss"

    ; Clean up python option
    Delete "$INSTDIR\python27.dll"
    Delete "$INSTDIR\python27.zip"

    ; Clean up NCC option
    RMDir /r "$INSTDIR\NCC\*"

    ; Clean up plugin options
	Delete "$INSTDIR\plugins\data\PyQt5\*"
    Delete "$INSTDIR\plugins\data\*"
    Delete "$INSTDIR\plugins\*.dll"
    Delete "$INSTDIR\plugins\*.py"

    ; Clean up tutorials option
    Delete "$INSTDIR\tutorials\*.js"
    Delete "$INSTDIR\tutorials\*.qml"

    ; Clean up translations option
    Delete "$INSTDIR\translations\*.qm"


	; Clean up Resources
    Delete "$INSTDIR\resources\*"

	;Clean up Stylesheets
	Delete "$INSTDIR\styles\*"



    MessageBox MB_YESNO|MB_ICONQUESTION \
            "Do you want to remove all data stored in the installation directory (Settings, Downloads, Installed Mods, Profiles)?$\r$\n\
            This does NOT remove instances created in AppData and if you changed data directories through settings, those are also not removed "  IDYES true IDNO false
            true:
				Delete "$INSTDIR\ModOrganizer.ini"
				RMDir /r "$INSTDIR\downloads\*"
				RMDir /r "$INSTDIR\mods\*"
				RMDir /r "$INSTDIR\overwrite\*"
				RMDir /r "$INSTDIR\profiles\*"
				RMDir /r "$INSTDIR\crashdumps\*"
			false:
				;Do nothing

    ReadRegStr $0 HKCU "Software\Classes\nxm\shell\open\command" ""
    ${UnStrLoc} $1 $0 $INSTDIR ">"
    ${If} $1 == 0
        DeleteRegValue HKCU "Software\Classes\nxm\shell\open\command" ""
        MessageBox MB_OK|MB_ICONINFORMATION \
            "This installation of Mod Organizer was set up to handle Nexus Download links. If you intend to use a different Mod Manager now you may have to associate it with those links. \
             How that works differs depending on the application:$\r$\n\
             - If it's a different MO instance, simply start it and hit the globe icon.$\r$\n\
             - If it's Nexus Mod Manager, start it as Administrator, go to settings->general and enable the $\"Associate with NXM URLs$\" option"
    ${Endif}


    ; Remove remaining directories (IF they are empty)
    RMDir "$SMPROGRAMS\Mod Organizer"
	RMDir "$INSTDIR\logs\"
    RMDir "$INSTDIR\downloads\"
    RMDir "$INSTDIR\stylesheets\"
    RMDir "$INSTDIR\mods\"
    RMDir "$INSTDIR\overwrite\"
    RMDir "$INSTDIR\plugins\data\PyQt5\"
    RMDir "$INSTDIR\plugins\data\"
    RMDir "$INSTDIR\plugins\"
    RMDir "$INSTDIR\profiles\"
    RMDir "$INSTDIR\platforms\"
	RMDir "$INSTDIR\QtQuick.2\"
    RMDir "$INSTDIR\licenses\"
    RMDir "$INSTDIR\DLLs\imageformats\"
    RMDir "$INSTDIR\DLLs\"
    RMDir "$INSTDIR\loot\"
    RMDir "$INSTDIR\translations\"
    RMDir "$INSTDIR\tutorials\"
	RMDir "$INSTDIR\resources\"
	RMDir "$INSTDIR\styles\"
    RMDir "$INSTDIR\"

SectionEnd

; eof
