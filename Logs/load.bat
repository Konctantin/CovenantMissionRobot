SET CUR_DIR=%~dp0
SET CUR_DIR=%CUR_DIR:\=/%

for %%f in (%CUR_DIR%\*.sql) do sqlcmd -f65001 -i "%%f"

