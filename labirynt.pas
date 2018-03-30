uses crt, ptcgraph;

var

//  ATRYBUTY-ZMIENNE

  blok,  atak,
  szybkosc, zycie,

  rezultat,
  mod_atak, mod_blok,

  posx, posy, posz, r,
  strona                 :array[1..10] of integer;

  kto, kogo_co,
  kogo_czego, nazwa      :array[1..10] of string;

  pd, poziom, akcje,
  zycie_max              :integer;


//  KOORDYNACJA-ZMIENNE

  sala, liczba_w,
  wygrana, diament,
  no, so, we, ea,
  nr, nr1, ilosc_graczy,
  obok                   :integer;

  c                      :char;

//  GRAFIKA-ZMIENNE

  x, y, a, b             :integer;
  sterownik, tryb        :SmallInt;

  tekst, tekst1          :string;

//  PROSTOKATY-ZMIENNE

  menu1                  :array [1..4] of Pointtype=((X:15;Y:15),(X:145;Y:15),(X:145;Y:820),(X:15;Y:820));
  menu2                  :array [1..4] of Pointtype=((X:0;Y:825),(X:1280;Y:825),(X:1280;Y:1024),(X:0;Y:1024));
  sal                    :array [1..4] of Pointtype=((X:365;Y:217),(X:915;Y:217),(X:915;Y:787),(X:365;Y:787));

//  KOLIZJA-ZMIENNE

  pozycja                :array [350..930, 222..802] of record
    kolizja, drzwi,
    postac, hi           :integer;
  end;


//                         GRAFIKA


procedure hud;{statystyki, oprawa graficzna menu}

var y                      :integer;

    atak_string, blok_string,
    zycie_string, pd_string,
    szybkosc_string,
    zycie_max_string,
    poziom_string          :string;

begin
  settextstyle(defaultfont,horizdir,1);
  setcolor(white);
  setfillstyle(emptyfill,black);
  fillpoly(4,menu1);
  fillpoly(4,menu2);

  line(0,getmaxy-100,getmaxx, getmaxy-100);
  line(150,0,150,getmaxy-100);

  str(atak[1],atak_string);
  atak_string:='Atak: '+atak_string;
  outtextxy(20,20,atak_string);

  str(blok[1], blok_string);
  blok_string:= 'Blok: '+blok_string;
  outtextxy(20,40,blok_string);

  str(szybkosc[1], szybkosc_string);
  szybkosc_string:='Szybkosc: '+szybkosc_string;
  outtextxy(20,60,szybkosc_string);

  if zycie[1]<0 then zycie[1]:=0;
  str(zycie[1],zycie_string);
  str(zycie_max,zycie_max_string);
  zycie_string:='Zycie: '+zycie_string+'/'+zycie_max_string;
  outtextxy(20,80,zycie_string);

  str(poziom,poziom_string);
  poziom_string:='Poziom: '+poziom_string;
  outtextxy(20,120,poziom_string);

  str(pd,pd_string);
  pd_string:= 'PD: '+pd_string+'/100';
  outtextxy(20,140,pd_string);

  outtextxy(20,getmaxy-70,tekst);
  outtextxy(20,getmaxy-50,tekst1);


end;


procedure text(a:string);
begin
  tekst:=a;
  tekst1:='';
  hud;
end;


procedure text(a,b:string);
begin
  tekst:=a;
  tekst1:=b;
  hud;
end;



procedure gracz;{kolko zielone ze wspolrzednymi gracza}
begin;
  setcolor(strona[nr]);
  setfillstyle(solidfill,strona[nr]);
  fillellipse(posx[nr],posy[nr],r[nr],r[nr]);
  pozycja[posx[nr],posy[nr]].kolizja:=1;
  pozycja[posx[nr],posy[nr]].postac:=nr;
  setcolor(white);
  outtextxy(posx[nr]-3,posy[nr]-3,nazwa[nr]);
end;


procedure gracz1;{kolko czarne ze wspolrzednymi gracza}
begin
  setcolor(black);
  setfillstyle(emptyfill,black);
  fillellipse(posx[nr],posy[nr],r[nr],r[nr]);
  pozycja[posx[nr],posy[nr]].kolizja:=0;
  pozycja[posx[nr],posy[nr]].postac:=0;
end;


procedure south;{rysunek drzwi poludniowych}
var a,b:integer;
begin
  setcolor(white);
  line(x-250,y+250,x+250,y+250);
  rectangle(x-30,y+245,x+30,y+255);
  b:=y+260;
  for a:=x-30 to x+30 do pozycja[a,b].drzwi:=1;
end;

procedure north;{rysunek drzwi polnocnych}
var a,b:integer;
begin
  setcolor(white);
  line(x-250,y-250,x+250,y-250);
  rectangle(x-30,y-255,x+30,y-245);
  b:=y-260;
  for a:=x-30 to x+30 do pozycja[a,b].drzwi:=1;
end;


procedure west;{rysunek drzwi zachodnich}
var a,b:integer;
begin
  setcolor(white);
  line(x-250,y-250,x-250,y+250);
  rectangle(x-255,y-30,x-245,y+30);
  a:=x-260;
  for b:=y-30 to y+30 do pozycja[a,b].drzwi:=1;
end;


procedure east;{rysunek drzwi wschodnich}
var a,b:integer;
begin
  setcolor(white);
  line(x+250,y-250,x+250,y+250);
  rectangle(x+245,y-30,x+255,y+30);
  a:=x+260;
  for b:=y-30 to y+30 do pozycja[a,b].drzwi:=1;
end;


procedure lawa(x, y:integer);{rysunek lawy o wspolrzednych wprowadzanych w nawiasie}
var a,b:integer;

begin
  setcolor(white);
  rectangle(x-25,y-80,x+25,y+80);
  rectangle(x-60,y-70,x-35,y+70);
  rectangle(x+35,y-70,x+60,y+70);
  for a:=x-65 to x-29 do for b:=y-70 to y+70 do pozycja[a,b].hi:=1;
  for a:=x+29 to x+65 do for b:=y-70 to y+70 do pozycja[a,b].hi:=1;
  for a:=x-29 to x+29 do for b:=y-80 to y+80 do pozycja[a,b].hi:=2;
end;


procedure intro;{intro do gry}
begin
writeln(x);
writeln(y);
  settextstyle(defaultfont,horizdir,2);

  outtextxy (x-536,y,'UWAGA! Program dziala poprawnie jedynie w rozdzielczosci 1280x1024.');
  settextstyle (defaultfont,horizdir,1);
  outtextxy (x-504,y+30,'Nie ponosimy odpowiedzialnosci za ewentualne straty moralne i intelektualne spowodowane gra w nieodpowiedniej rozdzielczosci.');
  outtextxy(x-120,y+70,'-- Nacisnij dowolny klawisz --');
  c:=readkey;


  cleardevice;
  settextstyle(defaultfont,horizdir,2);
  setcolor(white);
  outtextxy(x-176,y,'MACIEJ Z. I MATEUSZ R.');
  delay(1000);

  setcolor(lightgray);
  outtextxy(x-104,y+40,'PRZEDSTAWIAJA:');
  delay(1000);
  cleardevice;

  setcolor(red);
  settextstyle(defaultfont,horizdir,3);
  outtextxy(x-276,y,'++ LABIRYNT TAJEMNIC ++');
  delay(2000);
  cleardevice;

  settextstyle(defaultfont,horizdir,1);
  hud;
end;


//                             SALE


procedure zeruj_drzwi;
var a,b:integer;
begin
  b:=y-260;
  for a:=x-30 to x+30 do pozycja[a,b].drzwi:=0;

  b:=y+260;
  for a:=x-30 to x+30 do pozycja[a,b].drzwi:=0;

  a:=x-260;
  for b:=y-30 to y+30 do pozycja[a,b].drzwi:=0;

  a:=x+260;
  for b:=y-30 to y+30 do pozycja[a,b].drzwi:=0;
end;


procedure zeruj_wyjscia;
begin
  no:=0;
  so:=0;
  we:=0;
  ea:=0;
end;


procedure sala_0;{rysunek podstawowej sali (samych scian, bez drzwi)}
begin
  setcolor(white);
  rectangle(x-250,y-250,x+250,y+250);
end;


procedure sala_1;{rysunek sali}
begin
  north;
  west;
  a:=x+20;
  b:=y-40;
  lawa(x+150,y+150);

end;


procedure sala_2;{rysunek sali}
begin
  east;
  west;
  south;
  a:=x+60;
  b:=y+20;
  lawa(x+150,y+150);

end;


procedure sala_3;{rysunek sali}
begin
  south;
  west;
  a:=x-100;
  b:=y-40;
  lawa(x+150,y+150);

end;


procedure sala_4;{rysunek sali}
begin
  north;
  west;
  east;
  a:=x-140;
  b:=y-140;
  lawa(x+150,y+150);

end;


procedure sala_5;{rysunek sali}
begin
  east;
  south;
  a:=x-80;
  b:=y+60;
  lawa(x+150,y+150);

end;


procedure sala_6;{rysunek sali}
begin
  north;
  south;
  a:=x+40;
  b:=y;
  lawa(x+150,y+150);

end;


procedure sala_7;{rysunek sali}
begin
  east;
  west;
  a:=x+100;
  b:=y-80;
  lawa(x+150,y+150);

end;


procedure sala_8;{rysunek sali}
begin
  north;
  west;
  a:=x;
  b:=y;
  lawa(x+150,y+150);

end;


procedure sala_9;{rysunek sali finalowej (z diamentem)}
begin

end;


procedure losuj_sale;{losowanie sali}
begin
  zeruj_wyjscia;
  randomize;
  sala:=random(diament+1)+1;
  if sala=1 then sala_1;
  if sala=2 then sala_2;
  if sala=3 then sala_3;
  if sala=4 then sala_4;
  if sala=5 then sala_5;
  if sala=6 then sala_6;
  if sala=7 then sala_7;
  if sala=8 then sala_8;
  if sala=9 then sala_9;
end;


procedure sala_graf;{rysunek calej sali razem z obiektami w srodku}
var a:integer;
begin
  sala_0;
  if no=1 then north;
  if so=1 then south;
  if we=1 then west;
  if ea=1 then east;
  if sala=1 then sala_1;
  if sala=2 then sala_2;
  if sala=3 then sala_3;
  if sala=4 then sala_4;
  if sala=5 then sala_5;
  if sala=6 then sala_6;
  if sala=7 then sala_7;
  if sala=8 then sala_8;
  if sala=9 then sala_9;
  a:=nr;
  for nr:=1 to ilosc_graczy do gracz;
  nr:=a;

end;


//                          UZYWANIE OBIEKTOW I KOLIZJA


procedure zeruj_kolizje;{podstawowa kolizja scian}
var a,b:integer;
begin
  for a:=x-260 to x+260 do
  begin
    b:=y-260;
    pozycja[a,b].kolizja:=1;
    pozycja[a,b].drzwi:=0;
    b:=y+260;
    pozycja[a,b].kolizja:=1;
    pozycja[a,b].drzwi:=0;
  end;

  for b:=y-260 to y+260 do
  begin
    a:=x-260;
    pozycja[a,b].kolizja:=1;
    pozycja[a,b].drzwi:=0;
    a:=x+260;
    pozycja[a,b].kolizja:=1;
    pozycja[a,b].drzwi:=0;
  end;

  for a:=x-250 to x+250 do for b:=y-250 to y+250 do
  begin
    with pozycja[a,b] do
    begin
      kolizja:=0;
      postac:=0;
      hi:=0;
    end;
  end;
end;


procedure ruch(a:string);{animacje ruchu z roznych ustawien}
var posz2:integer;
    dif:real;
begin
  posz2:=posz[nr];

  if a='w' then posy[nr]:=posy[nr]-20
  else if a='s' then posy[nr]:=posy[nr]+20
  else if a='a' then posx[nr]:=posx[nr]-20
  else if a='d' then posx[nr]:=posx[nr]+20;

  with pozycja[posx[nr],posy[nr]] do
  begin
    posz[nr]:=hi;
  end;

  if posz2>posz[nr] then
  begin
    dif:= posz2-posz[nr];
    r[nr]:=r[nr]-round(dif*2);
  end
  else if posz2<posz[nr] then
  begin
    dif:=posz[nr]-posz2;
    r[nr]:=r[nr]+round(dif*2);
  end

  else if posz2=posz[nr] then dif:=0.5;

  akcje:=akcje-round(dif*2);

end;




//                          POTWORY

procedure zeruj_wrogow;
begin
  ilosc_graczy:=1;
  for nr:=2 to 10 do
  begin
    posz[nr]:=0;
    r[nr]:=0;
    posx[nr]:=0;
    posy[nr]:=0;
    strona[nr]:=0;
    nazwa[nr]:='';

    blok[nr]:=0;
    atak[nr]:=0;
    szybkosc[nr]:=0;
    zycie[nr]:=0;
    kto[nr]:='';
    kogo_co[nr]:='';
    kogo_czego[nr]:='';
  end;
end;


procedure liczba_wroga;
begin
  randomize;
  liczba_w:=1;
end;


procedure pozycja_wroga;
begin
  randomize;
  repeat until pozycja[a,b].kolizja<>1;
  begin
    a:=random(25);
    a:=a*20+x-240;
    b:=random(25);
    b:=b*20+y-240;
  end;
end;


procedure ork;
begin
  pozycja_wroga;
  nr:=2;
  repeat inc(nr) until zycie[nr]<1;
  inc(ilosc_graczy);

  posz[nr]:=0;
  r[nr]:=10;
  posx[nr]:=a;
  posy[nr]:=b;
  strona[nr]:=4;
  nazwa[nr]:='o';

  blok[nr]:=5;
  atak[nr]:=7;
  szybkosc[nr]:=4;
  zycie[nr]:=30;
  kto[nr]:='Ork';
  kogo_co[nr]:='orka';
  kogo_czego[nr]:='orka';

  gracz;
end;


procedure goblin;
begin
  pozycja_wroga;
  nr:=2;
  repeat inc(nr) until zycie[nr]<1;
  inc(ilosc_graczy);

  posz[nr]:=0;
  r[nr]:=10;
  posx[nr]:=a;
  posy[nr]:=b;
  strona[nr]:=4;
  nazwa[nr]:='g';

  blok[nr]:=4;
  atak[nr]:=5;
  szybkosc[nr]:=6;
  zycie[nr]:=20;
  kto[nr]:='Goblin';
  kogo_co[nr]:='goblina';
  kogo_czego[nr]:='goblina';

  gracz;
end;


procedure szkielet;
begin
  pozycja_wroga;
  nr:=2;
  repeat inc(nr) until zycie[nr]<1;
  inc(ilosc_graczy);

  posz[nr]:=0;
  r[nr]:=10;
  posx[nr]:=a;
  posy[nr]:=b;
  strona[nr]:=4;
  nazwa[nr]:='s';

  blok[nr]:=3;
  atak[nr]:=10;
  szybkosc[nr]:=4;
  zycie[nr]:=25;
  kto[nr]:='Szkielet';
  kogo_co[nr]:='szkielet';
  kogo_czego[nr]:='szkieletu';

  gracz;
end;


procedure troll;
begin
  pozycja_wroga;
  nr:=2;
  repeat inc(nr) until zycie[nr]<1;
  inc(ilosc_graczy);

  posz[nr]:=0;
  r[nr]:=10;
  posx[nr]:=a;
  posy[nr]:=b;
  strona[nr]:=4;
  nazwa[nr]:='T';

  blok[nr]:=12;
  atak[nr]:=20;
  szybkosc[nr]:=3;
  zycie[nr]:=70;
  kto[nr]:='Troll';
  kogo_co[nr]:='trolla';
  kogo_czego[nr]:='trolla';

  gracz;
end;


procedure tur;
begin
  pozycja_wroga;
  nr:=2;
  repeat inc(nr) until zycie[nr]<1;
  inc(ilosc_graczy);

  posz[nr]:=0;
  r[nr]:=10;
  posx[nr]:=a;
  posy[nr]:=b;
  strona[nr]:=4;
  nazwa[nr]:='t';

  blok[nr]:=11;
  atak[nr]:=10;
  szybkosc[nr]:=6;
  zycie[nr]:=50;
  kto[nr]:='Tur';
  kogo_co[nr]:='tura';
  kogo_czego[nr]:='tura';

  gracz;
end;


procedure rodzaj_wroga;
var a:integer;
begin
  writeln('a');
  randomize;
  a:=random(10)+1;
  if (a>0) and (a<4) then ork
  else if (a>3) and (a<7) then goblin
  else if (a>6) and (a<9) then szkielet
  else if a=9 then troll
  else if a=10 then tur;
end;


procedure losuj_wroga;
begin
  liczba_wroga;
  while ilosc_graczy<liczba_w+1 do rodzaj_wroga;
  nr:=1;
end;


//                          PRZEJSCIA
procedure zero;
begin
  zeruj_drzwi;
  zeruj_wyjscia;
  zeruj_kolizje;
  zeruj_wrogow;
end;

procedure wejscie_south;{animacja wejscia do sali przez poludniowe drzwi}
  var i:integer;
begin

  zero;
  nr:=1;
  fillpoly(4,sal);
  sala_0;
  posy[nr]:=y+250;
  losuj_sale;
  so:=1;
  losuj_wroga;

  for i := y+250 downto y+240 do
  begin
    posy[1]:= i;
    gracz;
    south;
    delay(20);
    gracz1;
  end;
  gracz;

end;


procedure wejscie_north;{animacja wejscia do sali przez polnocne drzwi}
  var i:integer;
begin

  zero;
  nr:=1;
  fillpoly(4,sal);
  sala_0;
  posy[nr]:=y-250;
  losuj_sale;
  no:=1;
  losuj_wroga;

  for i:= y-250 to y-240 do
  begin
    posy[1] := i;
    gracz;
    north;
    delay(20);
    gracz1;
  end;
  gracz;

end;


procedure wejscie_west;{animacja wejscia do sali przez zachodnie drzwi}
  var i:integer;
begin


  zero;
  nr:=1;
  fillpoly(4,sal);
  sala_0;
  posx[nr]:=x-250;
  losuj_sale;
  we:=1;
  losuj_wroga;

  for i:= x-250 to x-240 do
  begin
    posx[1] := i;
    gracz;
    west;
    delay(20);
    gracz1;
  end;
  gracz;

end;


procedure wejscie_east;{animacja wejscia do sali przez wschodnie drzwi}

  var i:integer;
  begin

  zero;
  nr:=1;
  fillpoly(4,sal);
  sala_0;
  posx[nr]:=x+250;
  losuj_sale;
  ea:=1;
  losuj_wroga;

  for i:= x+250 downto x+240 do
  begin
    posx[1] := i;
    gracz;
    east;
    delay(20);
    gracz1;
  end;
  gracz;
end;


//                      KOORDYNACJA


procedure nowa;{procesy po rozpoczeciu nowej gry}
begin

  fillpoly(4,sal);
  settextstyle(defaultfont,horizdir,1);

  nr:=1;
  ilosc_graczy:=1;
  diament:=7;
  blok[1]:=10;
  atak[1]:=10;
  zycie_max:=20;
  zycie[1]:=20;
  poziom:=1;
  pd:=0;
  r[1]:=10;
  posx[1]:=x;
  posz[1]:=0;
  strona[1]:=2;
  obok:=0;
  szybkosc[1]:=5;
  kto[1]:='Gracz';
  kogo_co[1]:='gracza';
  kogo_czego[1]:='gracza';

  cleardevice;
  settextstyle(defaultfont,horizdir,2);
  outtextxy(x-152,y,'!!! OSTRZEZENIE !!!');
  settextstyle(defaultfont,horizdir,1);
  outtextxy(x-548,y+20,'Wszyscy wrogowie napotkani w grze to postacie fikcyjne. Animuja ich zawodowi idioci. Dla wlasnego bezpieczenstwa nie probuj ich nasladowac.');
  c:=readkey;

  cleardevice;
  text('Podczas swoich wedrowek trafiles na wejscie do tajemniczego labiryntu wykutego w poteznej skale. Kierujac sie zadza przygod, wchodzisz do srodka.');
  c:=readkey;
  wejscie_south;
  text('','');
  c:='1';
end;


procedure menu;{menu glowne wlaczajace sie po zakonczeniu intra}
begin
  repeat
  begin
    text('','');
    setcolor(white);
    settextstyle(defaultfont,horizdir,2);
    outtextxy(x,y,'Menu Glowne');
    outtextxy(x-20,y+30,'1-Nowa gra');
    outtextxy(x-20,y+60,'2-Wczytaj gre');
    outtextxy(x-20,y+90,'3-Koniec');
    c:=readkey;

    if c='1'then nowa
    else if c='3' then halt;
  end;
  until (c='1') or (c='3');
end;


//                        MODYFIKATORY

procedure mod0;
begin
  if posz[nr]=0 then
  begin
    mod_atak[nr]:=0;
    mod_blok[nr]:=0;
  end;

  if posz[nr]=1 then
  begin
    mod_atak[nr]:=2;
    mod_blok[nr]:=-1;
  end;

  if posz[nr]=2 then
  begin
    mod_atak[nr]:=4;
    mod_blok[nr]:=-2;
  end;
end;


procedure mod1;
var a:integer;
begin
  a:=nr;
  mod0;
  nr:=nr1;
  mod0;
  atak[nr]:=atak[nr]+mod_atak[nr];
  blok[nr]:=blok[nr]+mod_blok[nr];
  atak[nr1]:=atak[nr1]+mod_atak[nr1];
  blok[nr1]:=blok[nr1]+mod_blok[nr1];
  nr:=a;
end;


procedure mod2;
begin
  a:=nr;
  mod0;
  nr:=nr1;
  mod0;
  atak[nr]:=atak[nr]-mod_atak[nr];
  blok[nr]:=blok[nr]-mod_blok[nr];
  atak[nr1]:=atak[nr1]-mod_atak[nr1];
  blok[nr1]:=blok[nr1]-mod_blok[nr1];
  nr:=a;
end;


//                         WALKA

procedure awans;
var a:string;
begin
  poziom:=poziom+1;
  text('Gratulacje! Masowa rzez potworow wiele Cie nauczyla. Wybierz atrybut, ktory chcesz rozwinac:', '1) Atak+5   2) Blok+5   3) Zycie+10   4) Szybkosc+1');
  readln(a);
  if c='1' then atak[1]:=atak[1]+5
  else if c='2' then blok[1]:=blok[1]+5
  else if c='3' then
  begin
    zycie[1]:=zycie[1]+10;
    zycie_max:=zycie_max+10;
  end
  else if c='4' then szybkosc[1]:=szybkosc[1]+1;
  text('','');
  pd:=0;
end;


procedure obrazenia;
var a:integer;
    b:string;
begin
  randomize;
  rezultat[nr]:=random(9)+1;
  zycie[nr1]:=zycie[nr1]-rezultat[nr];

  if zycie[nr1]<1 then
  begin
    a:=nr;
    nr:=nr1;
    gracz1;
    nr:=a;
    ilosc_graczy:=ilosc_graczy-1;
    atak[nr1]:=0;
    blok[nr1]:=0;
    szybkosc[nr1]:=0;
    zycie[nr1]:=0;

    if zycie[1]<1 then
    begin
      text('Bron przeciwnika rozcina Twoja czaszke na dwie rowne czesci. Tak sie dziwnie sklada, ze giniesz.');
      c:=readkey;
      cleardevice;
      settextstyle(defaultfont,horizdir,2);
      setcolor(red);
      outtextxy(x-104,y,'GRA SKONCZONA');
      delay(3000);
      cleardevice;
      setcolor (white);
      outtextxy(x-352,y,'Ale laskawie pozwolimy Ci zagrac jeszcze raz');
      delay(5000);
      cleardevice;
      hud;
      menu;
    end

    else
    begin
      text('Twoje uderzenie posyla mozg przeciwnika na sciane. Teraz nie wciskaj nam, ze sciana jest za daleko i idz siepac dalej.');
      c:=readkey;
      pd:=pd+20;
      if pd=100 then awans;
    end;
  end;
end;


procedure atakowanie;
begin
  akcje:=0;
  mod1;
  gracz;
  randomize;
  rezultat[nr]:=random(9)+1;
  rezultat[nr]:=rezultat[nr]+atak[nr];
  rezultat[nr1]:=random(9)+1;
  rezultat[nr1]:=rezultat[nr1]+blok[nr1];

  if rezultat[nr]>=rezultat[nr1] then
  begin
    text((kto[nr]+' trafia '+kogo_co[nr1]+'.'));
    delay(2000);
    obrazenia;
  end

  else if rezultat[nr]<rezultat[nr1] then
  begin
    text((kto[nr]+' nie trafia '+kogo_czego[nr1]+'.'));
    delay(2000);
  end;
  mod2;
end;





//                         RUCH


procedure sprawdz_w;{sprawdzenie kolizji na polnoc od gracza}
begin
  gracz1;

  with pozycja[posx[nr],posy[nr]-20] do
  begin
    if kolizja=0 then ruch('w')

    else if kolizja=1 then
    begin

      if drzwi=1 then wejscie_south

      else if postac>0 then
      begin
        nr1:=postac;
        atakowanie;
      end;
    end;

    sala_graf;
    gracz;
  end;
end;


procedure sprawdz_s;{sprawdzenie kolizji na poludnie od gracza}
begin
  gracz1;

  with pozycja[posx[nr],posy[nr]+20] do
  begin

    if kolizja=0 then ruch('s')

    else if kolizja=1 then
    begin
      if drzwi=1 then wejscie_north

      else if postac>0 then
      begin
        nr1:=postac;
        atakowanie;
      end;
    end;

    sala_graf;
    gracz;
  end;
end;


procedure sprawdz_a;{sprawdzenie kolizji na zachod od gracza}
begin
  gracz1;
  with pozycja[posx[nr]-20,posy[nr]] do
  begin

    if kolizja=0 then ruch('a')

    else if kolizja=1 then
    begin
      if drzwi=1 then wejscie_east

      else if postac>0 then
      begin
        nr1:=postac;
        atakowanie;
      end;
    end;

    sala_graf;
    gracz;
  end;
end;


procedure sprawdz_d;{sprawdzenie kolizji na wschod od gracza}
begin
  gracz1;
  with pozycja[posx[nr]+20,posy[nr]] do
  begin

    if kolizja=0 then ruch('d')

    else if kolizja=1 then
    begin
      if drzwi=1 then wejscie_west

      else if postac>0 then
      begin
        nr1:=postac;
        atakowanie;
      end;
    end;

    sala_graf;
    gracz;
  end;
end;


procedure kolo;
begin
  if ((posx[nr]=posx[1]) AND (posy[nr]=posy[1]-20))

     OR

     ((posx[nr]=posx[1]+20) AND (posy[nr]=posy[1]))

     OR

     ((posx[nr]=posx[1]-20) AND (posy[nr]=posy[1]))

     OR

     ((posx[nr]=posx[1]) AND (posy[nr]=posy[1]+20)) then obok:=1


     else obok:=0;
end;


procedure ai;
var a:integer;
begin


  if posx[nr]<posx[1] then
  begin

    if posy[nr]<posy[1] then
    begin
      a:=random(2);
      if a=0 then sprawdz_s;
      if a=1 then sprawdz_d;
    end

    else if posy[nr]=posy[1] then sprawdz_d

    else if posy[nr]>posy[1] then
    begin
      a:=random(2);
      if a=0 then sprawdz_w;
      if a=1 then sprawdz_d;
    end;
  end


  else if posx[nr]=posx[1] then
  begin

    if posy[nr]<posy[1] then sprawdz_s

    else if posy[nr]>posy[1] then sprawdz_w;
  end


  else if posx[nr]>posx[1] then
  begin

    if posy[nr]<posy[1] then
    begin
      a:=random(2);
      if a=0 then sprawdz_s;
      if a=1 then sprawdz_a;
    end

    else if posy[nr]=posy[1] then sprawdz_a

    else if posy[nr]>posy[1] then
    begin
      a:=random(2);
      if a=0 then sprawdz_w;
      if a=1 then sprawdz_a;
    end;
  end;
end;


procedure ruch;{wybieranie kierunku chodu}
begin
  if nr>1 then
  begin
    ai;
    kolo;
    delay(500);
  end

  else if nr=1 then
  begin
    c:='0';
    c:=readkey;
    if c='w' then sprawdz_w
    else if c='s' then sprawdz_s
    else if c='a' then sprawdz_a
    else if c='d' then sprawdz_d
    else if c='x' then halt;
  end;
end;




//                         AKCJA

procedure akcja;{tu na razie jest sciernisko, ale bedzie San Fransisco...
Czyli jednym slowem wszystko, co sie dzieje po wejsciu do sali}
begin
  if ilosc_graczy=1 then
  begin
    nr:=1;
    repeat ruch until ilosc_graczy>1;
  end

  else if ilosc_graczy>1 then
  begin
    for nr:=1 to ilosc_graczy do
    begin
      if zycie[nr]>0 then
      begin
        if nr=1 then
        begin
          akcje:=szybkosc[1];
          repeat ruch until akcje<1;
        end

        else if nr>1 then
        begin
          akcje:=szybkosc[nr];
          repeat ruch until (akcje<1) or (obok=1);
          if (obok=1) and (akcje>0) then ai;
        end;
      end;
    end;
    nr:=1;
  end;
end;



//                 PROGRAMISZCZE


begin{cala gra, intro i menu glowne}
  clrscr;
  initgraph(sterownik,tryb,'');
  x:=getmaxx div 2;
  y:=getmaxy div 2;
  readln;
  intro;
  menu;
  repeat akcja until wygrana=1;

  hud;
  fillpoly(4,sal);
  outtextxy(x-185,y,'Gratulacje! Zdobyles Diament Krolow!');
end.


