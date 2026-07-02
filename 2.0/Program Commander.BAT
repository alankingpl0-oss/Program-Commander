@echo off

color EC
setlocal enabledelayedexpansion

:menu
cls
echo ==========================================================================
echo  WWW.ALANKING.PL     PROGRAM COMMANDER (PCD) Alan Makowski
echo ==========================================================================
echo ZARZADZANIE PLIKAMI                     ^|  USTAWIENIA i OPCJE PROGRAMU
echo ==========================================================================
echo 1. Wyswietl zawartosc katalogu          I
echo 2. Otworz plik lub folder w nowym oknie I  
echo 3. Zmien katalog (DIR)                  I
echo 4. ZAKONCZ                              I  p. Personalizacja interfejsu
echo 5. Utworz plik                          I j Zmien jezyk (wkrotce dostepne)
echo 6. Utworz katalog (DIR)                 I
echo 7. Zmien nazwe                          ^|
echo 10. Historia wykonanych dzialan         I                 
echo 11. Wyczysc historie dzialan            I
echo 12. Analizuj katalog (DIR)              ^|
echo 13. Komprezuj do archiwum (ZIP)         I=================================
echo 14. Wyszukaj pliki                      I Program powstal 14.03.25,
echo 15. Nowy plik tekstowy (.TXT)           I
echo 16. przegladaj pliki tekstowy (.TXT)    I ostatnia aktualizacja 17.03.25.
echo ==========================================================================
set /p choice=Wybierz opcje: 

if "%choice%"=="1" goto list_dir
if "%choice%"=="2" goto open_item
if "%choice%"=="3" goto change_dir
if "%choice%"=="4" goto exit
if "%choice%"=="5" goto create_file
if "%choice%"=="6" goto create_dir
if "%choice%"=="7" goto rename_item
if "%choice%"=="10" goto view_history
if "%choice%"=="11" goto clear_history
if "%choice%"=="p" goto customize_colors
if "%choice%"=="r" goto reset_colors
if "%choice%"=="info" goto info
if "%choice%"=="12" goto analyze_folder
if "%choice%"=="13" goto create_zip
if "%choice%"=="14" goto search_files
if "%choice%"=="15" goto create_new_file
if "%choice%"=="16" goto view_txt_files
echo Niepoprawny wybor. Sprobuj ponownie.
pause
goto menu

:list_dir
cls
echo ==========================================================================
echo                      ZAWARTOSC AKTUALNEGO KATALOGU
echo ==========================================================================
dir /b
call :log_action "Wyswietlono zawartosc katalogu %cd% (Data: %date% Godzina: %time%)"
pause
goto menu

:open_item
cls
set /p item=Podaj nazwe pliku lub katalogu do otwarcia: 
if exist "%item%" (
    start "" "%item%"
    call :log_action "Otworzono %item% (Data: %date% Godzina: %time%)"
    echo Otworzono %item%.
) else (
    echo Plik lub katalog %item% nie istnieje!
)
pause
goto menu

:change_dir
cls
set /p newdir=Podaj sciezke katalogu, do ktorego chcesz przejsc: 
if exist "%newdir%" (
    cd /d "%newdir%"
    call :log_action "Zmiana katalogu na %newdir% (Data: %date% Godzina: %time%)"
    echo Zmieniono katalog na: %newdir%.
) else (
    echo Katalog %newdir% nie istnieje!
)
pause
goto menu

:create_file
cls
set /p newfile=Podaj nazwe pliku do utworzenia (np. plik.txt): 
if exist "%newfile%" (
    echo Plik %newfile% juz istnieje!
) else (
    echo. > "%newfile%"
    call :log_action "Utworzono plik: %newfile% (Data: %date% Godzina: %time%)"
    echo Plik %newfile% zostal utworzony.
)
pause
goto menu

:create_dir
cls
set /p newdir=Podaj nazwe katalogu do utworzenia: 
if exist "%newdir%" (
    echo Katalog %newdir% juz istnieje!
) else (
    mkdir "%newdir%"
    call :log_action "Utworzono katalog: %newdir% (Data: %date% Godzina: %time%)"
    echo Katalog %newdir% zostal utworzony.
)
pause
goto menu

:rename_item
cls
set /p oldname=Podaj nazwe istniejacego pliku/katalogu: 
if not exist "%oldname%" (
    echo Plik lub katalog %oldname% nie istnieje!
    pause
    goto menu
)
set /p newname=Podaj nowa nazwe: 
rename "%oldname%" "%newname%"
call :log_action "Zmieniono nazwe z %oldname% na %newname% (Data: %date% Godzina: %time%)"
echo Nazwa %oldname% zostala zmieniona na %newname%.
pause
goto menu

:view_history
cls
echo ==========================================================================
echo                       HISTORIA WYKONANYCH DZIALAN
echo ==========================================================================
if not exist log.txt (
    echo Brak zapisanych dzialan.
    pause
    goto menu
)
type log.txt
pause
goto menu

:clear_history
cls
echo Czyszczenie historii dzialan...
timeout /t 2 > nul
del log.txt
echo Historia zostala wyczyszczona!
pause
goto menu

:log_action
rem Funkcja dodająca wpis do logu
echo %~1 >> log.txt
exit /b

:customize_colors
cls
echo ==========================================================================
echo                     PERSONALIZACJA INTERFEJSU
echo ==========================================================================
echo Wybierz schemat kolorow:          0. Wlasny - samodzielnie podaj kolory
echo 1. Domyslny - jasnozolte tlo, czerwony tekst
echo 2. Kontrastowy - Czarne tlo, jasnozolty tekst
echo 3. Nocny - czarne tlo, bialy tekst
echo 4. Dzienny - Biale tlo, czarny tekst
echo 5. Czerwone tlo, zolty tekst (mniej polecane)
echo 6. Jasnozolte tlo, czarny tekst    
echo ==========================================================================
set /p choice=Wybierz opcje (1-5): 

if "%choice%"=="1" (color EC & call :save_color "EC" & goto menu)
if "%choice%"=="2" (color 0E & call :save_color "0E" & goto menu)
if "%choice%"=="3" (color 07 & call :save_color "07" & goto menu)
if "%choice%"=="4" (color F0 & call :save_color "F0" & goto menu)
if "%choice%"=="5" (color CE & call :save_color "CE" & goto menu)
if "%choice%"=="6" (color E0 & call :save_color "E0" & goto menu)
if "%choice%"=="0" goto custom_color
echo Niepoprawny wybor. Sprobuj ponownie.
pause
goto customize_colors

:search_files
cls
echo ==========================================================================
echo                        WYSZUKIWANIE PLIKOW
echo ==========================================================================
echo Podaj wzorzec wyszukiwania, np.:
echo - *.txt  (wszystkie pliki tekstowe)
echo - *nazwa* (pliki zawierajace "nazwa" w nazwie)
echo - *       (wszystkie pliki)
echo Wpisz 'menu', aby wrocic do menu glownego.
echo ==========================================================================
set /p search=Podaj wzorzec: 

:: Opcja powrotu do menu glownego
if /i "%search%"=="menu" goto menu

:: Wyszukiwanie plikow
echo Szukam plikow pasujacych do wzorca: %search%
dir %search% /s /b

:: Opcja zapisu wynikow do pliku
echo ==========================================================================
echo Czy chcesz zapisac wyniki wyszukiwania do pliku? (t/n)
set /p save_to_file=
if /i "%save_to_file%"=="t" (
    dir %search% /s /b > search_results.txt
    echo Wyniki zapisano w pliku search_results.txt
)

:: Powrot do menu glownego
echo ==========================================================================
echo Nacisnij dowolny klawisz, aby wrocic do menu glownego.
pause
goto menu

:reset_colors
cls
if exist color_config.txt (
    set /p default_color=<color_config.txt
    color %default_color%
    call :log_action "Kolory ustawiono na domyslne: %default_color% (Data: %date% Godzina: %time%)"
    echo Przywrócono kolory do domyślnych z pliku color_config.txt: %default_color%.
) else (
    echo Plik color_config.txt nie istnieje! Upewnij się, że plik zawiera domyślny kod koloru.
)
pause
goto menu


:save_color
echo %1>color_config.txt
call :log_action "Zapisano kolor interfejsu: %1 (Data: %date% Godzina: %time%)"
exit /b

:custom_color
cls
echo ==========================================================================
echo                  USTAWIANIE WLASNEGO SCHEMATU KOLOROW
echo ==========================================================================
echo Podaj kolor tla i tekstu w formacie XY:
echo X - kolor tla, Y - kolor tekstu.
echo Dostepne kolory:
echo 0 - Czarny, 1 - Niebieski, 2 - Zielony, 3 - Turkusowy
echo 4 - Czerwony, 5 - Fioletowy, 6 - Zolty, 7 - Bialy
echo 8 - Szary, 9 - Jasnoniebieski, A - Jasnozielony
echo B - Jasnoturkusowy, C - Jasnoczerwony, D - Jasnofioletowy
echo E - Jasnozolty, F - Intensywnie bialy
echo ==========================================================================
set /p custom=Podaj kod koloru: 
color %custom%
call :save_color "%custom%"
goto menu

:info
cls
echo ==========================================================================
echo         INFO O PROGRAMIE
echo ==========================================================================
echo Jezeli chcesz zmienic kolor domyslny, wejdz do pliku config_colors.txt
echo tam zmienisz kolor na domyslny.
call :log_action "Wejscie w 'info': %1 (Data: %date% Godzina: %time%)"
pause
goto menu

:exit
cls
echo ==========================================================================
echo                 Dziekujemy za skorzystanie z Program Commander!
echo ==========================================================================
pause
exit

:analyze_folder
cls
echo ==========================================================================
echo                      ANALIZA FOLDERU
echo ==========================================================================
set /p folder=Podaj sciezke folderu do analizy: 

:: Sprawdzenie, czy folder istnieje
if not exist "%folder%" (
    echo Podany folder nie istnieje! Sprawdz sciezke i sproboj ponownie.
    pause
    goto menu
)

echo Analizuje folder: %folder%
set "file_count=0"
set "total_size=0"

:: Liczenie liczby plików
for /f "tokens=5*" %%A in ('dir "%folder%" /a:-d /s ^| findstr "plikow Plik"') do (
    set /a file_count+=%%A
)

:: Obliczanie całkowitego rozmiaru plików
for /f "tokens=3" %%A in ('dir "%folder%" /a:-d /s ^| findstr "bajtow Ogolnie"') do (
    set /a total_size+=%%A
)

:: Wyświetlanie wyników analizy w konsoli
echo ==========================================================================
echo Wyniki analizy:
echo - Liczba plikow w folderze: %file_count%
echo - Calkowity rozmiar plikow: %total_size% bajtow
echo ==========================================================================
echo Najwieksze pliki w folderze:
dir "%folder%" /a:-d /s /o:-s | findstr /V "katalog" | more
echo ==========================================================================
pause
goto menu

:create_zip
cls
echo ==========================================================================
echo                   TWORZENIE ARCHIWUM ZIP
echo ==========================================================================
set /p source=Podaj sciezke do plikow lub katalogu do spakowania: 

if not exist "%source%" (
    echo Podany plik lub katalog nie istnieje! Sprawdz sciezke i sproboj ponownie.
    pause
    goto menu
)

set /p zipname=Podaj nazwe pliku ZIP (np. archiwum.zip): 
if exist "%zipname%" (
    echo Plik %zipname% juz istnieje! Wybierz inna nazwe.
    pause
    goto create_zip
)

echo Tworzenie archiwum ZIP...
powershell Compress-Archive -Path "%source%" -DestinationPath "%zipname%"
if %errorlevel%==0 (
    echo Archiwum ZIP zostalo utworzone: %zipname%
    call :log_action "Utworzono archiwum ZIP: %zipname% ze zrodla %source% (Data: %date% Godzina: %time%)"
) else (
    echo Wystapil blad podczas tworzenia archiwum ZIP.
)
pause
goto menu

:create_new_file
cls
set /p newfile=Podaj nazwe nowego pliku (np. nowy.txt): 
set /p folder=Podaj sciezke katalogu, gdzie zapisac plik (np. C:\Dokumenty): 

:: Sprawdzenie, czy podany katalog istnieje
if not exist "%folder%" (
    echo Podany katalog nie istnieje! Sproboj ponownie.
    pause
    goto create_new_file
)


echo Wpisz swoj tekst ponizej. Aby zapisac i wyjsc, wpisz ,,ZAPISZ'' w nowej linii.
echo ==========================================================================
:write_new
set /p line=
if /i "%line%"=="ZAPISZ" goto save_new_file
echo %line% >> "%folder%\%newfile%"
goto write_new



:save_new_file
echo Plik zostal zapisany w lokalizacji: %folder%\%newfile%.
pause
goto menu

:view_txt_files
cls
echo ==========================================================================
echo                 PRZEGLADANIE PLIKOW TEKSTOWYCH (.TXT)
echo ==========================================================================
echo Dostepne pliki tekstowe w bieżącym katalogu:
dir *.txt /b
echo ==========================================================================
set /p txtfile=Podaj nazwe pliku do przegladania (lub wpisz 'menu', aby wrocic): 

if /i "%txtfile%"=="menu" goto menu
if not exist "%txtfile%" (
    echo Podany plik nie istnieje! Sproboj ponownie.
    pause
    goto view_txt_files
)

echo ==========================================================================
echo ZAWARTOSC PLIKU: %txtfile%
echo ==========================================================================
type "%txtfile%"
echo ==========================================================================
echo Nacisnij dowolny klawisz, aby wrocic do menu glownego.
set /p choice=Wybierz opcje (1-5): 

pause
goto menu


