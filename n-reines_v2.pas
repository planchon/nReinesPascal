PROGRAM nReines_v2;

uses sysutils, crt;

CONST
	// forcement >= 5
	tailleGrille = 8;

VAR
	counter : integer;

TYPE tabEch = array of array of boolean;

TYPE echec = RECORD
	tab : tabEch;
	tabAttack : tabEch;
	n : integer;
END;

TYPE arrEchec = array of tabEch;
TYPE arrayInt = array of integer;
TYPE finalArrayInt = array of arrayInt;

// afficher le tab
PROCEDURE afficher(tab : tabEch);
VAR
	i, j : integer;
BEGIN
	FOR i := 0 TO tailleGrille - 1 DO
	BEGIN
		FOR j := 0 TO tailleGrille - 1 DO
		BEGIN
			IF tab[i,j] THEN
				write('x ')
			ELSE
				write('. ');
		END;
		writeln();
	END;
END;

// init les valeurs d'un tab a 0. Il faut que le tab ai deja sa taille.
PROCEDURE initTab(VAR tab : tabEch);
VAR
	i,j : integer;
BEGIN
	FOR i := 0 TO tailleGrille - 1 DO
	BEGIN
		FOR j := 0 TO tailleGrille - 1 DO
		BEGIN
			tab[i, j] := False;
		END;
	END;
END;

// met a jour le tableau de tabAttack
PROCEDURE updateTabAttack (x,y : integer; VAR tab : echec);
VAR
	i, j : integer;
BEGIN
	i := x;
	j := y;
	
	// diagonales haut gauche
	WHILE (j >= 0) and (i >= 0) DO
	BEGIN
		tab.tabAttack[i, j] := True;
		dec(i);
		dec(j);
	END;
	
	i := x;
	j := y;
	
	WHILE (j <= tailleGrille - 1) and (i >= 0) DO
	BEGIN
		tab.tabAttack[i, j] := True;
		dec(i);
		inc(j);
	END;
	
	i := x;
	j := y;
	
	WHILE (j >= 0) and (i <= tailleGrille - 1) DO
	BEGIN
		tab.tabAttack[i, j] := True;
		inc(i);
		dec(j);
	END;
	
	i := x;
	j := y;
	
	WHILE (j <= tailleGrille - 1) and (i <= tailleGrille - 1) DO
	BEGIN
		tab.tabAttack[i, j] := True;
		inc(i);
		inc(j);
	END;
END;

// (x,y) pos de la nouvelle reine on teste ca
// TRUE  => on peut poser une reine en x,y
// FALSE => on peut pas 
FUNCTION testerPos(x, y : integer; tab : echec) : boolean;
BEGIN
	testerPos := not tab.tabAttack[x,y];
END;

// on teste toute les positions du tableau proposé par l'algo de heap
// TRUE  => le tableau marche
// FALSE => le tableau marche pas
FUNCTION testerTableau(tab : arrayInt) : boolean;
VAR
	i : integer;
	stop : boolean;
	ech : echec;
BEGIN
	stop := false;
	i := 0;
	
	setLength(ech.tab, length(tab), length(tab));
	setLength(ech.tabAttack, length(tab), length(tab));
	
	initTab(ech.tab);
	initTab(ech.tabAttack);
	
	WHILE (not stop) and (i < length(tab)) DO
	BEGIN
		// on regarde si on peut poser une reine avec la mapAttack update
		IF testerPos(i, tab[i], ech) THEN
		BEGIN
			ech.tab[i, tab[i]] := True;
			updateTabAttack(i, tab[i], ech);
			inc(i);
		END
		ELSE
		BEGIN
			stop := true;
		END;
	END;
	
	testerTableau := not stop;
END;

// on converti un tab de position (int) vers un tab de pos en boolean
FUNCTION convertIntToTab(tab : arrayInt) : tabEch;
VAR
	i : integer;
	finalTab : tabEch;
BEGIN
	setLength(finalTab, length(tab), length(tab));
	initTab(finalTab);
	
	FOR i := 0 TO tailleGrille - 1 DO
	BEGIN
		finalTab[i, tab[i]] := True;
	END;
	
	convertIntToTab := finalTab;
END;

// on echange deux valeurs dans un tableau
PROCEDURE swap(VAR tab : arrayInt; a, b : integer);
VAR
	temp : integer;
BEGIN
	temp   := tab[a];
	tab[a] := tab[b];
	tab[b] := temp;
END;

// check pour les doublons
// TRUE  => c'est un doublon
// FALSE => c'est pas un doublon
FUNCTION doublon (tab : arrayInt; bigTab : finalArrayInt) : boolean;
VAR
	i, j : integer;
	stop1, stop2 : boolean;
BEGIN
	// on cherche un doublon sur tous les elements de la liste
	// on s'arrete quand on en a trouve un.
	
	stop1 := False;
	stop2 := False;
	i := 0;
	j := 0;
	
	WHILE (not stop1) and (i < length(bigTab)) DO
	BEGIN
		stop2 := False;
		j := 0;
		WHILE (not stop2) and (j < length(bigTab[i])) DO
		BEGIN
			// tant que les elements sont les meme on continue. Est ce un doublon ?
			IF tab[j] = bigTab[i,j] THEN
				inc(j)
			ELSE
			// ca en est pas un
				stop2 := True;
		END;
		
		// on ne s'est pas arreter. C'est un doublon
		IF not stop2 THEN
			stop1 := True
		ELSE
			inc(i);
	END;
	
	doublon := stop1;
END;

PROCEDURE output(tab : arrayInt; VAR tabEchec : finalArrayInt);
BEGIN
	IF testerTableau(tab) THEN
	BEGIN
		if not doublon(tab, tabEchec) then
		BEGIN
			tabEchec[counter] := tab;
			inc(counter);
			setLength(tabEchec, counter+1, tailleGrille);
		END;
	END;
END;

PROCEDURE heap(n : integer; A : arrayInt; VAR tabEchec : finalArrayInt);
VAR
	i : integer;
	C : arrayInt;
BEGIN
	setLength(C, n);
	FOR i := 0 TO n - 2 DO 
		C[i] := 0;
	
	output(A, tabEchec);
	
	i := 0;
	
	WHILE i < n DO
	BEGIN
		IF C[i] < i THEN
		BEGIN
			IF i MOD 2 = 0 THEN
				swap(A, 0, i)
			ELSE
				swap(A, C[i], i);
				
			output(A, tabEchec);
			
			inc(c[i]);
			i := 0;
		END
		ELSE
		BEGIN
			c[i] := 0;
			inc(i);
		END;
	END;
END;

VAR
	tabEchec : finalArrayInt;
	tab : arrayInt;
	i,ii : integer;
BEGIN
	setLength(tab, tailleGrille);
	setLength(tabEchec, 1, tailleGrille);
	
	FOR i := 1 TO tailleGrille DO
	BEGIN
		tab[i] := i;
	END;
	
	counter := 0;
	
	heap(tailleGrille, tab, tabEchec);
	
	
	FOR i := 0 TO length(tabEchec) - 2 DO 
	BEGIN
		FOR ii := 0 TO tailleGrille - 1 DO
		BEGIN
			write(' ', tabEchec[i,ii]);
		END;
		writeln();
		//afficher(convertIntToTab(tabEchec[i]));
	END;
	
	writeln('Les solutions sont :', length(tabEchec) - 1);
END.
