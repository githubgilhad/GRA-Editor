GRA-Editor
=================

DOS Editor pro grafické soubory ve formatu GRA

Formát GRA umožňuje ukládat a načítat grafiku


Rozměr obrázku je 160x200 pixelů, je rozdělen na pole 8x8 pixelů (je jich 500), kde každé pole má přiřazeny 4 barvy z palety pro celý obrázek, která obsahuje 16 barev. Barva 0 se považuje za průhlednou.
Každý pixel tedy má hodnotu 0-3, která je indexem do palety pole, která obsahuje 4 hodnoty 1-15, které jsou indexem do palety obrázku, která obsahuje 16 32bitových barev.

Soubor se ukládá tak, že 4 po sobě jdoucí pixely se slouží do jednoho byte, vznikne pole 8.000 bytů, za něj se připojí palety polí, 500x4 byty a za něj se připojí paleta obrázku 16x4 byty. Celkem 10.064 bytů
Toto výsledné pole se zkomprimuje do zmodifikovaného RLE formátu a do souboru se zapíše jeho délka na 2byty a následně celé zkomprimované pole. Soubor obsahuje právě jeden obrázek.

Zmodifikovaný RLE formát
Pokud se po sobě jdoucí hodnoty liší, zapisují se přímo
Pokud je 2-255 stejných hodnot za sebou, zapíše se hodnota dvakrát, pak (počet opakování -1) a tento úsek se přeskočí.
Načítání probíhá podobně.

Paleta pole obsahuje 4 byty s hodnotami 0-15
Paleta obrázku obsahuje 16 čtveřic bytů s významem (R,G,B,c) v tomto pořadí.
