@echo off
setlocal enabledelayedexpansion


set "local_version=3.3.2"

mode con: cols=110 lines=30

color 1f


:: Pobieranie wersji z internetu
set "online_version="
for /f "delims=" %%v in ('powershell -Command "try { (Invoke-WebRequest -Uri 'http://www.kolejopedia.pl/pcd-wer.txt' -UseBasicParsing).Content.Trim() } catch { '' }" 2^>nul') do (
    set "online_version=%%v"
)

set "update_msg="
if defined online_version (
    if not "!online_version!"=="%local_version%" (
        set "update_msg=NOWA WERSJA DOSTEPNA: !online_version!. Twoja wersja: %local_version%"
    )
)

:menu
cls
if defined update_msg (
    echo.
    echo  %update_msg%
    echo.
)


rem cls
rem echo Diagnostyka: doszło do tego miejsca
rem pause
echo ==================================================================================================
echo  HTTP://WWW.KOLEJOPEDIA.PL/MAKSOFT     PROGRAM COMMANDER (PCD) - MAKSOFT, AlanKingPL
echo ==================================================================================================
echo ZARZADZANIE PLIKAMI                     ^|  USTAWIENIA i OPCJE PROGRAMU
echo ==================================================================================================
echo Jestes w: %cd%
echo ==================================================================================================
echo 1. Wyswietl zawartosc katalogu          I                              I  CO NOWEGO W 3.3?       I
echo 2. Otworz plik lub folder w nowym oknie I                              I                         I
echo 3. Zmien katalog (DIR)                  I                              I Zobacz plik             I
echo 4. ZAKONCZ                              I p. Personalizacja interfejsu I                         I
echo 5. Utworz plik                          I                              I                         I
echo 6. Utworz katalog (DIR)                 I i. Informacje o programie    I       AKTUALIZACJA.TXT  I
echo 7. Zmien nazwe                          I                              I                         I
echo 10. Historia wykonanych dzialan         I                              I  aby dowiedziec sie     I
echo 11. Wyczysc historie dzialan            I                              I                         I
echo 12. Analizuj katalog (DIR)              I                              I wiecej o aktualizacjach I
echo 13. Komprezuj do archiwum (ZIP)         I=========================================================
echo 14. Wyszukaj pliki                      I Program powstal 14.03.25,
echo 15. Nowy plik tekstowy (.TXT)           I
echo 16. przegladaj pliki tekstowy (.TXT)    I ostatnia aktualizacja 3.10.25.
echo 17. Szukaj frazy w plikach (.TXT)
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
if /i "%choice%"=="p" goto customize_colors
if /i "%choice%"=="r" goto reset_colors
if /i "%choice%"=="i" goto info
if "%choice%"=="12" goto analyze_folder
if "%choice%"=="13" goto create_zip
if "%choice%"=="14" goto search_files
if "%choice%"=="15" goto create_new_file
if "%choice%"=="16" goto view_txt_files
if "%choice%"=="17" goto search_word_in_txt
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
if exist log.txt del /f /q log.txt
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
echo 1. Domyslny - niebieskie, bialy tekst
echo 2. Kontrastowy - Czarne tlo, jasnozolty tekst
echo 3. Nocny - czarne tlo, bialy tekst
echo 4. Dzienny - Biale tlo, czarny tekst
echo 5. Czerwone tlo, zolty tekst (mniej polecane)
echo 6. Jasnozolte tlo, czarny tekst    
echo ==========================================================================
set /p choice_col=Wybierz opcje (0-6): 

if "%choice_col%"=="1" (color 1f & call :save_color "ef" & goto menu)
if "%choice_col%"=="2" (color 0E & call :save_color "0E" & goto menu)
if "%choice_col%"=="3" (color 07 & call :save_color "07" & goto menu)
if "%choice_col%"=="4" (color F0 & call :save_color "F0" & goto menu)
if "%choice_col%"=="5" (color CE & call :save_color "CE" & goto menu)
if "%choice_col%"=="6" (color E0 & call :save_color "E0" & goto menu)
if "%choice_col%"=="0" goto custom_color
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
    echo Plik color_config.txt nie istnieje! Upewnij sie, ze plik zawiera domyslny kod koloru.
)
pause
goto menu

:save_color
echo %~1>color_config.txt
call :log_action "Zapisano kolor interfejsu: %~1 (Data: %date% Godzina: %time%)"
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

rem                                                                                                       INFORMACJE O PROGRAMIE

:info
cls
echo ==========================================================================
echo                          INFORMACJE O PROGRAMIE
echo ==========================================================================
echo.
echo Program napisany zostal poczatkowo przez uzytkownika o pseudoniemie
echo AlanKingPL. Czyli przeze mnie. Pozniej, i zreszta do dzisiaj, program
echo jest rozwijany przez Maksoft. 
echo Nadal jestem zwiazany z tym programem, poniewaz naleze do Maksoftu.
echo.
echo Na poczatku, mialem plan, aby funkcje jak kopiowanie, przeno-
echo szenie plikow zostaly, ale gdy przy kopiowaniu cos sie zepsulo, usunalem
echo te funkcje.
echo.
echo  Ten program, nie powstalby, gdyby nie autor, i testerzy:
ECHO. 
echo AlanKingPL------ DYREKTOR PROJEKTU----------\
echo                                              =---------- Maksoft
echo LMX -------------TESTER---------------------/
echo.
echo Oraz inni testerzy.
echo.
echo (C) MAKSOFT 2023 - 2025, AlanKingPL 2021 - 2025. 
REM echo Jezeli chcesz zmienic kolor domyslny, wejdz do pliku color_config.txt
REM echo tam zmienisz kolor na domyslny.
REM call :log_action "Wejscie w 'info' (Data: %date% Godzina: %time%)"
pause
goto menu

:exit
cls
echo ==========================================================================
echo                 Dziekujemy za skorzystanie z Program Commander!
echo ==========================================================================
pause
endlocal
exit

:analyze_folder_STARSZY
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

:: Liczenie liczby plików (prosty, nieidealny dla wszystkich lokalizacji językowych)
for /f "tokens=5*" %%A in ('dir "%folder%" /a:-d /s ^| findstr /R /C:"[0-9][0-9]* plik"') do (
    set /a file_count+=%%A
)

:: Obliczanie całkowitego rozmiaru plików - może być przybliżone zależnie od formatu dir
for /f "tokens=3" %%A in ('dir "%folder%" /a:-d /s ^| findstr /R /C:"[0-9][0-9]* bajt"') do (
    set /a total_size+=%%A
)

echo ==========================================================================
echo Wyniki analizy:
echo - Liczba plikow w folderze: %file_count%
echo - Calkowity rozmiar plikow: %total_size% bajtow
echo ==========================================================================
echo Najwieksze pliki w folderze:
dir "%folder%" /a:-d /s /o:-s | findstr /V /I "katalog" | more
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
powershell -Command "try { Compress-Archive -Path '%source%' -DestinationPath '%zipname%' -Force; exit 0 } catch { exit 1 }"
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
call :log_action "Utworzono nowy plik tekstowy: %folder%\%newfile% (Data: %date% Godzina: %time%)"
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
pause
goto menu


:analyze_folder
cls
echo ==========================================================================
echo                      ANALIZA FOLDERU - ROZSZERZONA
echo ==========================================================================
set /p folder=Podaj sciezke folderu do analizy: 

:: Sprawdzenie, czy folder istnieje
if not exist "%folder%" (
    echo Podany folder nie istnieje! Sprawdz sciezke i sproboj ponownie.
    pause
    goto menu
)

echo Analizuje folder: %folder%
echo.

:: Liczenie liczby wszystkich plików i całkowitego rozmiaru
set "file_count=0"
set "total_size=0"
for /f "tokens=3,5" %%A in ('dir "%folder%" /a:-d /s ^| findstr /R /C:"[0-9][0-9]* bajt"') do (
    set /a total_size+=%%A
    set /a file_count+=1
    call :spinner
)

echo ==================================================================
echo - Liczba plikow w folderze: %file_count%
echo - Calkowity rozmiar plikow: %total_size% bajtow
echo ==================================================================

:: Podział plików wg rozszerzeń
echo Podzial plikow wedlug typow:
setlocal enabledelayedexpansion
for /f "tokens=*" %%F in ('dir "%folder%" /a:-d /b /s') do (
    set "ext=%%~xF"
    if defined ext (
        set /a count_!ext!+=1
        set /a size_!ext!+=%%~zF
    ) else (
        set /a count_NOEXT+=1
        set /a size_NOEXT+=%%~zF
    )
)
for /f "tokens=2 delims== " %%G in ('set count_ 2^>nul') do (
    set "ext_name=%%G"
    set /a c=!count_%%G!
    set /a s=!size_%%G!
    echo   %%G : !c! plikow, !s! bajtow
)
endlocal
echo ==================================================================

:: 5 Najwiekszych plikow
echo Najwieksze pliki w folderze:
echo ==================================================================
for /f "delims=" %%A in ('dir "%folder%" /a:-d /s /o:-s /b') do (
    set /a counter+=1
    echo %%A
    if !counter! geq 5 goto after_top5
)
:after_top5
set counter=0
echo ==================================================================

:: Opcja eksportu do pliku
set /p savefile=Chcesz zapisac wyniki analizy do raport_analizy.txt? (t/n): 
if /i "%savefile%"=="t" (
    echo Analiza folderu: %folder% > raport_analizy.txt
    echo Liczba plikow: %file_count% >> raport_analizy.txt
    echo Caly rozmiar plikow: %total_size% bajtow >> raport_analizy.txt
    echo. >> raport_analizy.txt
    echo Podzial wedlug typow: >> raport_analizy.txt
    setlocal enabledelayedexpansion
    for /f "tokens=2 delims== " %%G in ('set count_ 2^>nul') do (
        set "ext_name=%%G"
        set /a c=!count_%%G!
        set /a s=!size_%%G!
        echo   %%G : !c! plikow, !s! bajtow >> raport_analizy.txt
    )
    endlocal
    echo Najwieksze pliki: >> raport_analizy.txt
    for /f "delims=" %%A in ('dir "%folder%" /a:-d /s /o:-s /b') do (
        set /a counter+=1
        echo %%A >> raport_analizy.txt
        if !counter! geq 5 goto after_save_top5
    )
    :after_save_top5
    set counter=0
    echo Wyniki zapisano w raport_analizy.txt
)
pause
goto menu



REM                                                         ANIMACJA KÓŁKA

:spinner
setlocal enabledelayedexpansion
set "chars=/|-\"
for /l %%i in (0,1,3) do (
    <nul set /p="!chars:~%%i,1! "
    ping -n 1 -w 150 127.0.0.1 >nul
    <nul set /p=""
)
endlocal
exit /b


:search_word_in_txt
cls
echo ==========================================================================
echo               WYSZUKIWANIE SLOWA W PLIKACH TEKSTOWYCH
echo ==========================================================================
set /p folder=Podaj folder do przeszukania (lub ENTER = obecny katalog): 
if "%folder%"=="" set "folder=%cd%"

set /p word=Podaj slowo do wyszukania: 

echo ==========================================================================
echo Wyniki wyszukiwania dla slowa: %word%
echo ==========================================================================

:: Szukanie i podświetlanie linii zawierających słowo
for /f "delims=" %%F in ('dir "%folder%\*.txt" /b /s') do (
    findstr /i "%word%" "%%F" >nul
    if !errorlevel! == 0 (
        echo Plik: %%F
        for /f "tokens=*" %%L in ('findstr /i "%word%" "%%F"') do (
            echo    %%L
        )
        echo ------------------------------------------------------------------
    )
)

echo ==========================================================================
pause
goto menu

