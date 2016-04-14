; Setup_Npgsql_Unpack.nsi
;
; Unpack binary files from Setup_Npgsql-2.2.5.0-net45.exe
; Download from https://github.com/npgsql/npgsql/releases
;
; Based on Seput_Npgsql.nsi
; Download from https://gist.github.com/kenjiuno/7985982
;
; Based on Setup_Npgsql-2.2.5.0-net45.exe console output during installation and uninstallation time
;
;--------------------------------
!define INSTALL_FILES_ROOT "D:\Temp\NSISMANGO\SourceNpgsql-2.2.5.0-net45"

!define APP "Npgsql"
!define VER "2.2.5.0"

;!define ASM20_35 "Npgsql, Version=${VER}, Culture=neutral, PublicKeyToken=5d8b90d52f46fda7"
!define ASM40_45 "Npgsql, Version=${VER}, Culture=neutral, PublicKeyToken=5d8b90d52f46fda7"

;!define ASM35ef "Npgsql.EntityFrameworkLegacy, Version=${VER}, Culture=neutral, PublicKeyToken=5d8b90d52f46fda7"
!define ASM40_45ef "Npgsql.EntityFrameworkLegacy, Version=${VER}, Culture=neutral, PublicKeyToken=5d8b90d52f46fda7"

;!define ASM40_45ef6 "Npgsql.EntityFramework, Version=${VER}, Culture=neutral, PublicKeyToken=5d8b90d52f46fda7"

;!define ASM20ms "Mono.Security, Version=2.0.0.0, Culture=neutral, PublicKeyToken=0738eb9f132ed756"
!define ASM40ms "Mono.Security, Version=4.0.0.0, Culture=neutral, PublicKeyToken=0738eb9f132ed756"

;!define FAC20_35 "Npgsql.NpgsqlFactory, ${ASM20_35}"
!define FAC40_45 "Npgsql.NpgsqlFactory, ${ASM40_45}"

;!define TTL_INST_PUBPOL "Install publisher policy: fix up Npgsql 2.1.x.x"

;!define DLL_PUBPOL "policy.2.0.Npgsql.dll"

; The name of the installer
Name "${APP} ${VER}"

; The file to write
OutFile "Setup_${APP}-${VER}-net45.exe"

; The default installation directory
;InstallDir "$APPDATA\${APP}\${VER}" ;$PROGRAMFILES\The Npgsql Development Team\Npgsql
InstallDir "$PROGRAMFILES\The Npgsql Development Team\Npgsql"
; Request application privileges for Windows Vista
RequestExecutionLevel admin

!include "LogicLib.nsh"

;--------------------------------

; Pages

;Page license
Page components
Page instfiles

;LicenseData README.rtf

;--------------------------------

; InstType "Install .NET2.0 ver to GAC"
; InstType "Install .NET3.5 ver to GAC"
; InstType "Install .NET4.0 ver to GAC"
; InstType "Install .NET4.5 ver to GAC"
; InstType "Uninstall"

!macro _DotNetAvail _a _b _t _f
  !insertmacro _LOGICLIB_TEMP
  StrCpy $_LOGICLIB_TEMP "0"
  StrCmp `${_b}` `` +3 0 ;if path is not blank, continue to next check
  IfFileExists `$WINDIR\Microsoft.NET\Framework\${_b}\*.*` 0 +2 ;if directory exists, continue to confirm exists
  StrCpy $_LOGICLIB_TEMP "1"
  StrCmp $_LOGICLIB_TEMP "1" `${_t}` `${_f}`
!macroend
!define DotNetAvail `"" DotNetAvail`

; !macro GACRemove20 ASM
;   ${If} ${DotNetAvail} "v2.0.50727"
;     Push $0
;     ExecWait '"$INSTDIR\Tools20\GACRemove.exe" "${ASM}"' $0
;     DetailPrint "RetCode: $0"
;     Pop $0
;   ${EndIf}
; !macroend

!macro GACRemove40 ASM
  ${If} ${DotNetAvail} "v4.0.30319"
    Push $0
    DetailPrint '"$INSTDIR\GACRemove.exe" "${ASM}"'
    nsExec::Exec '"$INSTDIR\GACRemove.exe" "${ASM}"'
    Pop $0 ; get error message, nsExec return on top of stack
    DetailPrint "RetCode: $0"
    Pop $0
  ${EndIf}
!macroend

; !macro GACInst20 PATH
;   ${If} ${DotNetAvail} "v2.0.50727"
;     Push $0
;     ExecWait '"$INSTDIR\Tools20\GACInstall.exe" "${PATH}"' $0
;     DetailPrint "RetCode: $0"
;     Pop $0
;   ${EndIf}
; !macroend

!macro GACInst40 PATH
  ${If} ${DotNetAvail} "v4.0.30319"
    Push $0
    DetailPrint '"$INSTDIR\GACInstall.exe" "${PATH}"'
    nsExec::Exec '"$INSTDIR\GACInstall.exe" "${PATH}"'
    Pop $0 ; get error message, nsExec return on top of stack
    DetailPrint "RetCode: $0"
    Pop $0
  ${EndIf}
!macroend

; !macro RegAdoNet20 MACHINECONFIG TYPE
;   ${If} ${FileExists} ${MACHINECONFIG}
;   ${AndIf} ${DotNetAvail} "v2.0.50727"
;     Push $0
;     Push $1
;
;     StrCpy $0 '"$INSTDIR\Tools20\ModifyDbProviderFactories.exe"'
;     StrCpy $0 '$0 "/add-or-replace"'
;     StrCpy $0 '$0 "${MACHINECONFIG}"'
;     StrCpy $0 '$0 "Npgsql Data Provider"'
;     StrCpy $0 '$0 "Npgsql"'
;     StrCpy $0 '$0 ".Net Data Provider for PostgreSQL"'
;     StrCpy $0 '$0 "${TYPE}"'
;     StrCpy $0 '$0 "support"'
;     StrCpy $0 '$0 "FF"'
;
;     ExecWait '$0' $1
;     DetailPrint "RetCode: $1"
;
;     Pop $1
;     Pop $0
;   ${EndIf}
; !macroend

!macro RegAdoNet40 MACHINECONFIG TYPE
  ${If} ${FileExists} ${MACHINECONFIG}
  ${AndIf} ${DotNetAvail} "v4.0.30319"
    Push $0
    ;Push $1
    Push $2

    ;StrCpy $0 '"$INSTDIR\Tools40\ModifyDbProviderFactories.exe"'
    StrCpy $2 '"$INSTDIR\ModifyDbProviderFactories.exe"'
    StrCpy $2 '$2 "/add-or-replace"'
    StrCpy $2 '$2 "${MACHINECONFIG}"'
    StrCpy $2 '$2 "Npgsql Data Provider"'
    StrCpy $2 '$2 "Npgsql"'
    StrCpy $2 '$2 ".Net Data Provider for PostgreSQL"'
    StrCpy $2 '$2 "${TYPE}"'
    StrCpy $2 '$2 "support"'
    StrCpy $2 '$2 "FF"'

    DetailPrint "$2"
    nsExec::Exec '$2'
    Pop $0 ; get error message, nsExec return on top of stack
    DetailPrint "RetCode: $0"

    ;Pop $1
    Pop $2
    Pop $0
  ${EndIf}
!macroend

; The stuff to install
;Section ""
Section
  ; SetOutPath "$INSTDIR\Tools20"
  ; File "bin\Debug-net20\GACInstall.*"
  ; File "bin\Debug-net20\GACRemove.*"
  ; File "bin\Debug-net20\ModifyDbProviderFactories.*"

  SetOutPath "$INSTDIR"
  File "${INSTALL_FILES_ROOT}\GACInstall.*"
  File "${INSTALL_FILES_ROOT}\GACRemove.*"
  File "${INSTALL_FILES_ROOT}\ModifyDbProviderFactories.*"
  File "${INSTALL_FILES_ROOT}\PrintAssemblyName.*"

  SetOutPath "$INSTDIR\Npgsql-2.2.5.0-net45-vs2012"
  File "${INSTALL_FILES_ROOT}\Npgsql-2.2.5.0-net45-vs2015\*.*"

  SetOutPath "$INSTDIR\Npgsql-2.2.5.0-net45-vs2013"
  File "${INSTALL_FILES_ROOT}\Npgsql-2.2.5.0-net45-vs2013\*.*"

  SetOutPath "$INSTDIR\Npgsql-2.2.5.0-net45-vs2015"
  File "${INSTALL_FILES_ROOT}\Npgsql-2.2.5.0-net45-vs2012\*.*"

  SetOutPath "$INSTDIR\lib\Mono.Security\4.0"
  File "${INSTALL_FILES_ROOT}\lib\Mono.Security\4.0\*.*"

  ; SetOutPath                                             "$INSTDIR\Release-net20"
  ; File /r /x "*.pdb" /x "*.xml"                        "Npgsql\bin\Release-net20\Npgsql.*"
  ;
  ; SetOutPath                                             "$INSTDIR\Release-net35"
  ; File /r /x "*.pdb" /x "*.xml"                        "Npgsql\bin\Release-net35\Npgsql.*"
  ; File /r /x "*.pdb" /x "*.xml" "Npgsql.EntityFramework\bin\Legacy-Release-net35\Npgsql.EntityFrameworkLegacy.*"

  ; SetOutPath                                             "$INSTDIR\Release-net40"
  ; File /r /x "*.pdb" /x "*.xml"                        "Npgsql\bin\Release-net40\Npgsql.*"
  ; File /r /x "*.pdb" /x "*.xml"        "Npgsql.EntityFramework\bin\Release-net40\Npgsql.EntityFramework.*"
  ; File /r /x "*.pdb" /x "*.xml" "Npgsql.EntityFramework\bin\Legacy-Release-net40\Npgsql.EntityFrameworkLegacy.*"

  SetOutPath "$INSTDIR\Npgsql-2.2.5.0-net45"
  File /r /x "*.pdb" /x "*.xml" "${INSTALL_FILES_ROOT}\Npgsql-2.2.5.0-net45\Npgsql.*"
  File /r /x "*.pdb" /x "*.xml" "${INSTALL_FILES_ROOT}\Npgsql-2.2.5.0-net45\Npgsql.EntityFramework.*"
  File /r /x "*.pdb" /x "*.xml" "${INSTALL_FILES_ROOT}\Npgsql-2.2.5.0-net45\Npgsql.EntityFrameworkLegacy.*"

  ; SetOutPath "$INSTDIR\Mono.Security\2.0"
  ; File            "lib\Mono.Security\2.0\*.*"

  ;SetOutPath "$INSTDIR\lib\Mono.Security\4.0"
  ;File "${INSTALL_FILES_ROOT}\lib\Mono.Security\4.0\*.*"



  ; SetOutPath "$INSTDIR\policies\net20\"
  ; File     "Npgsql\bin\policies\net20\*.*"
  ;
  ; SetOutPath "$INSTDIR\policies\net40"
  ; File     "Npgsql\bin\policies\net40\*.*"

SectionEnd

; un 2.0 3.5
; un 2.0 3.5
; un 2.0 3.5

; SectionGroup "Uninstall from .NET2.0/3.5"
;   Section
;     SectionIn 5
;     SetOutPath "$INSTDIR"
;     !insertmacro GACRemove20 "${ASM20_35}"
;     !insertmacro GACRemove20 "${ASM35ef}"
;     !insertmacro GACRemove20 "${ASM20ms}"
;   SectionEnd
;   Section "Unregister from machine.config"
;     SectionIn 5
;     SetOutPath "$INSTDIR"
;
;     ${If} ${FileExists}                                                    "$WINDIR\Microsoft.NET\Framework\v2.0.50727\Config\machine.config"
;       ExecWait '"$INSTDIR\Tools20\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework\v2.0.50727\Config\machine.config" "Npgsql"' $0
;       DetailPrint "RetCode: $0"
;     ${EndIf}
;
;     ${If} ${FileExists}                                                    "$WINDIR\Microsoft.NET\Framework64\v2.0.50727\Config\machine.config"
;       ExecWait '"$INSTDIR\Tools20\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework64\v2.0.50727\Config\machine.config" "Npgsql"' $0
;       DetailPrint "RetCode: $0"
;     ${EndIf}
;   SectionEnd
; SectionGroupEnd

; SectionGroup "Uninstall from .NET4.0/4.5"
;   Section
;     SectionIn 5
;     !insertmacro GACRemove40 "${ASM40_45}"
;     !insertmacro GACRemove40 "${ASM40_45ef}"
;     !insertmacro GACRemove40 "${ASM40_45ef6}"
;     !insertmacro GACRemove40 "${ASM40ms}"
;   SectionEnd
;   Section "Unregister from machine.config"
;     SectionIn 5
;     SetOutPath "$INSTDIR"
;
;     ${If} ${FileExists}                                                    "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
;       ExecWait '"$INSTDIR\Tools40\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config" "Npgsql"' $0
;       DetailPrint "RetCode: $0"
;     ${EndIf}
;
;     ${If} ${FileExists}                                                    "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config"
;       ExecWait '"$INSTDIR\Tools40\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" "Npgsql"' $0
;       DetailPrint "RetCode: $0"
;     ${EndIf}
;   SectionEnd
; SectionGroupEnd

; inst 20 35
; inst 20 35
; inst 20 35

; SectionGroup "Install .NET2.0 ver to GAC"
;   Section
;     SectionIn 1
;     SetOutPath "$INSTDIR"
;     !insertmacro GACInst20 "$INSTDIR\Release-net20\Npgsql.dll"
;   SectionEnd
;   Section "Register to machine.config"
;     SectionIn 1
;     SetOutPath "$INSTDIR"
;     !insertmacro RegAdoNet20   "$WINDIR\Microsoft.NET\Framework\v2.0.50727\Config\machine.config" "${FAC20_35}"
;     !insertmacro RegAdoNet20 "$WINDIR\Microsoft.NET\Framework64\v2.0.50727\Config\machine.config" "${FAC20_35}"
;   SectionEnd
;   Section "${TTL_INST_PUBPOL}"
;     SetOutPath "$INSTDIR"
;     !insertmacro GACInst20 "$INSTDIR\policies\net20\${DLL_PUBPOL}"
;   SectionEnd
; SectionGroupEnd
;
; SectionGroup "Install .NET3.5 ver to GAC"
;   Section
;     SectionIn 2
;     SetOutPath "$INSTDIR"
;     !insertmacro GACInst20 "$INSTDIR\Release-net35\Npgsql.dll"
;     !insertmacro GACInst20 "$INSTDIR\Release-net35\Npgsql.EntityFrameworkLegacy.dll"
;   SectionEnd
;   Section "Register to machine.config"
;     SectionIn 2
;     SetOutPath "$INSTDIR"
;     !insertmacro RegAdoNet20   "$WINDIR\Microsoft.NET\Framework\v2.0.50727\Config\machine.config" "${FAC20_35}"
;     !insertmacro RegAdoNet20 "$WINDIR\Microsoft.NET\Framework64\v2.0.50727\Config\machine.config" "${FAC20_35}"
;   SectionEnd
;   Section "${TTL_INST_PUBPOL}"
;     SetOutPath "$INSTDIR"
;     !insertmacro GACInst20 "$INSTDIR\policies\net20\${DLL_PUBPOL}"
;   SectionEnd
; SectionGroupEnd

; inst 40 45
; inst 40 45
; inst 40 45

; SectionGroup "Install .NET4.0 ver to GAC"
;   Section
;     SectionIn 3
;     SetOutPath "$INSTDIR"
;     !insertmacro GACInst40 "$INSTDIR\Release-net40\Npgsql.dll"
;     !insertmacro GACInst40 "$INSTDIR\Release-net40\Npgsql.EntityFramework.dll"
;     !insertmacro GACInst40 "$INSTDIR\Release-net40\Npgsql.EntityFrameworkLegacy.dll"
;     !insertmacro GACInst40 "$INSTDIR\Mono.Security\4.0\Mono.Security.dll"
;   SectionEnd
;   Section "Register to machine.config"
;     SectionIn 3
;     SetOutPath "$INSTDIR"
;     !insertmacro RegAdoNet40   "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config" "${FAC40_45}"
;     !insertmacro RegAdoNet40 "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" "${FAC40_45}"
;   SectionEnd
;   Section "${TTL_INST_PUBPOL}"
;     SetOutPath "$INSTDIR"
;     !insertmacro GACInst40 "$INSTDIR\policies\net40\${DLL_PUBPOL}"
;   SectionEnd
; SectionGroupEnd

SectionGroup "Install .NET4.5 ver to GAC"
  Section "Add dll files to GAC"
    ;SectionIn 4
    SetOutPath "$INSTDIR"
    !insertmacro GACInst40 "$INSTDIR\Npgsql-2.2.5.0-net45\Npgsql.dll"
    ;!insertmacro GACInst40 "$INSTDIR\Npgsql-2.2.5.0-net45\Npgsql.EntityFramework.dll"
    !insertmacro GACInst40 "$INSTDIR\Npgsql-2.2.5.0-net45\Npgsql.EntityFrameworkLegacy.dll"
    !insertmacro GACInst40 "$INSTDIR\lib\Mono.Security\4.0\Mono.Security.dll"
  SectionEnd
  Section "Register to machine.config"
    ;SectionIn 4
    SetOutPath "$INSTDIR"
    !insertmacro RegAdoNet40   "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config" "${FAC40_45}"
    !insertmacro RegAdoNet40 "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" "${FAC40_45}"
  SectionEnd
  ; Section "${TTL_INST_PUBPOL}"
  ;   SetOutPath "$INSTDIR"
  ;   !insertmacro GACInst40 "$INSTDIR\policies\net40\${DLL_PUBPOL}"
  ; SectionEnd
SectionGroupEnd

; Section
;   DetailPrint "Visit NuGet site for public release: https://www.nuget.org/packages/Npgsql"
;   RMDir /r "$INSTDIR"
;   DetailPrint "Visit NuGet site for public release: https://www.nuget.org/packages/Npgsql"
; SectionEnd

Section "-Post"
  WriteUninstaller "$INSTDIR\uninstall.exe"
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "DisplayIcon" "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "DisplayName" "${APP} ${VER} - .Net Data Provider for Postgresql"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "DisplayVersion" "${VER}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "Publisher" "The Npgsql Development Team"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "NoModify" 1
  WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "NoRepair" 1
  SetRebootFlag false
SectionEnd


Section "Uninstall"

  DetailPrint "Uninstall .NET4.5 ver to GAC"

  !insertmacro GACRemove40 "${ASM40_45}"
  !insertmacro GACRemove40 "${ASM40_45ef}"
  ;!insertmacro GACRemove40 "${ASM40_45ef6}"
  !insertmacro GACRemove40 "${ASM40ms}"

  DetailPrint "Unregister from machine.config"

  ;SetOutPath "$INSTDIR"

  ${If} ${FileExists}                                                    "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config"
    ;ExecWait '"$INSTDIR\Tools40\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config" "Npgsql"' $0
    Push $0
    DetailPrint '"$INSTDIR\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config" "Npgsql"'
    nsExec::Exec '"$INSTDIR\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework\v4.0.30319\Config\machine.config" "Npgsql"'
    Pop $0 ; get error message, nsExec return on top of stack
    DetailPrint "RetCode: $0"
    Pop $0
  ${EndIf}

  ${If} ${FileExists}                                                    "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config"
    ;ExecWait '"$INSTDIR\Tools40\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" "Npgsql"' $0
    Push $0
    DetailPrint '"$INSTDIR\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" "Npgsql"'
    nsExec::Exec '"$INSTDIR\ModifyDbProviderFactories.exe" "/remove" "$WINDIR\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" "Npgsql"'
    Pop $0 ; get error message, nsExec return on top of stack
    DetailPrint "RetCode: $0"
    Pop $0
  ${EndIf}

  ; Remove registry keys
  DetailPrint "Clean ${APP} registry"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APP}"

  ; Delete Files
  RMDir /r "$INSTDIR"
SectionEnd
