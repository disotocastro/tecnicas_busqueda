program MochilaGreedy;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

// Variables Globales
var
  MochilaMaxPeso, i: Integer;
  peso, beneficio, calidadPrecio: array of Integer;
  Lista: TStringList;

// Leer los datos en forma de string
function LeerDatos(const Prompt: String): TStringList;
var
  InputLine: String;
begin
  Write(Prompt);
  Readln(InputLine);
  Result := TStringList.Create;
  Result.Delimiter := ' ';
  Result.DelimitedText := InputLine;
end;

// IMPRIMIR ARRAY
procedure ImprimirArrays(const Pesos, Beneficios: array of Integer);
var
  i: Integer;
begin
  WriteLn('Objetos registrados:');
  for i := Low(Pesos) to High(Pesos) do
  begin
    WriteLn('Objeto[', i + 1, '] con peso: ', Pesos[i], ', y beneficio: ', Beneficios[i]);
  end;
end;


// BUSQUEDA GREEDY
// Se crea un objeto que contiene ID, peso, beneficio y calidad/precio
type
  TObjeto = record
    Peso: Integer;
    Beneficio: Integer;
    CalidadPrecio: Real;
    ID: Integer;
  end;

// Implementaci�n sencilla del algoritmo bubblesort
// para ordenar los datos y que sea m�s sencillo escoger
// el mayor indice
procedure BubbleSort(var Objetos: array of TObjeto);
var
  i, j: Integer;
  Temp: TObjeto;
begin
  for i := Low(Objetos) to High(Objetos) - 1 do
    for j := Low(Objetos) to High(Objetos) - i - 1 do
      if Objetos[j].CalidadPrecio < Objetos[j + 1].CalidadPrecio then
      begin
        Temp := Objetos[j];
        Objetos[j] := Objetos[j + 1];
        Objetos[j + 1] := Temp;
      end;
end;


procedure Greedy(MochilaMaxPeso: Integer; var Objetos: array of TObjeto);

var
  i, PesoActual, BeneficioActual: Integer;
  ObjetoSeleccionado: TObjeto;

begin
  // Calcular calidad precio para cada objeto
  for i := Low(Objetos) to High(Objetos) do
  begin
    Objetos[i].CalidadPrecio := (Objetos[i].Beneficio / Objetos[i].Peso);
    Objetos[i].ID := i + 1;
  end;

  // Se ordenan los objetos por medio del algoritmo de burbuja
  BubbleSort(Objetos);

  // Algoritmo Greedy, selecciona los de mejor beneficio
  PesoActual := 0;
  BeneficioActual := 0;
  WriteLn('Objetos seleccionados para la mochila:');
  for i := Low(Objetos) to High(Objetos) do
  begin
    if PesoActual + Objetos[i].Peso <= MochilaMaxPeso then
    begin
      PesoActual := PesoActual + Objetos[i].Peso;
      BeneficioActual := BeneficioActual + Objetos[i].Beneficio;
      WriteLn('Objeto[', Objetos[i].ID, '] con peso: ', Objetos[i].Peso, ', beneficio: ', Objetos[i].Beneficio);
    end;
  end;

  WriteLn('Peso final de la mochila: ', PesoActual);
  WriteLn('Beneficio final de la mochila: ', BeneficioActual);


end;


// MAIN
var
  opcionMenu: Integer; Objetos: array of TObjeto;

begin
  // Solicitar el peso m�ximo de la mochila
  Write('Ingresa el peso m�ximo de la mochila: ');
  Readln(MochilaMaxPeso);

  // Leer y almacenar los pesos
  Lista := LeerDatos('Ingresa por favor el arreglo de pesos (ejemplo: 1 2 3 4 5): ');
  try
    SetLength(peso, Lista.Count);
    for i := 0 to Lista.Count - 1 do
      peso[i] := StrToInt(Lista[i]);
  finally
    Lista.Free;
  end;

  // Leer y almacenar los beneficios
  Lista := LeerDatos('Ingresa por favor el arreglo de beneficios (ejemplo: 1 2 3 4 5): ');
  try
    SetLength(beneficio, Lista.Count);
    for i := 0 to Lista.Count - 1 do
      beneficio[i] := StrToInt(Lista[i]);
  finally
    Lista.Free;
  end;


  // Imprimir los arrays de Pesos y Beneficios
  ImprimirArrays(peso, beneficio);
  Readln;


  // Crear y llenar el array de TObjeto
  SetLength(Objetos, Length(peso));
  for i := 0 to High(Objetos) do
  begin
    Objetos[i].Peso := peso[i];
    Objetos[i].Beneficio := beneficio[i];
  end;


  // Imprimir el menu
  WriteLn('Selecciona el algoritmo de b�squeda:');
  WriteLn('1 - Greedy');
  WriteLn('2 - Fuerza bruta (Exhaustiva pura)');
  WriteLn('3 - Backtracking (B�squeda Exhaustiva con Ramificaci�n y Acotamiento)');
  ReadLn(opcionMenu);

  case opcionMenu of
    1: Greedy(MochilaMaxPeso, Objetos);
    //2: FuerzaBruta;
    //3: Backtracking;
  else
    WriteLn('Opci�n no v�lida.');
  end;

  ReadLn;
end.