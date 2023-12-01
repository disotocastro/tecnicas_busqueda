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



//       ===== METODOS DE BUSQUEDA =====
//Se crea un objeto que contiene ID, peso, beneficio y calidad/precio}
type
  TObjeto = record
    Peso: Integer;
    Beneficio: Integer;
    CalidadPrecio: Real;
    ID: Integer;
end;

{
  ALGORITMO DE BUSQUEDA BURBUJA
  Se implementa para ordenar el array de TObjetos, esto con el fin
  de facilitarle al algoritmo Greedy obtener los valores de calidad/precio
  y escogerlos de una manera m�s r�pida.

  Se escoge implementar este algoritmo porque es bueno en N peque�os y
  su implementanci�n es sencilla.

}
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


// === BUSQUEDA GREEDY ===
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



// ===== FUERZA BRUTA =====
procedure FuerzaBruta(MochilaMaxPeso: Integer; var Objetos: array of TObjeto);
var
  MejorBeneficio, BeneficioActual, PesoActual: Integer;
  MejorCombinacion, CombinacionActual: array of Boolean;
  i: Integer;

  {
    ProbarCombinacion es un procedimiento anidado recursivo
    que explora todas las combinaciones posibles de objetos
  }

  procedure ProbarCombinacion(indice: Integer);
  var
    j: Integer; // Variable local para el bucle for dentro del procedimiento anidado
  begin
    // Si se han considerado todos los objetos, se eval�a la combinaci�n actual
    if indice > High(Objetos) then
    begin

      PesoActual := 0;
      BeneficioActual := 0;
      // Calcular el peso y beneficio totales de la combinaci�n actual

      for j := Low(Objetos) to High(Objetos) do
      begin
        if CombinacionActual[j] then

        begin
          PesoActual := PesoActual + Objetos[j].Peso;
          BeneficioActual := BeneficioActual + Objetos[j].Beneficio;
        end;
      end;

      {
        Si la combinaci�n actual aun cabe en la mochila y tiene mejor beneficio
        que la anterior mejor se actualiza la mejor combinaci�n
      }

      if (PesoActual <= MochilaMaxPeso) and (BeneficioActual > MejorBeneficio) then
      begin
        MejorBeneficio := BeneficioActual;
        MejorCombinacion := Copy(CombinacionActual);
      end;
      Exit;
    end;
    // Explorar la combinaci�n incluyendo el objeto actual
    CombinacionActual[indice] := True;
    ProbarCombinacion(indice + 1);
    // Explorar la combinaci�n excluyendo el objeto actual
    CombinacionActual[indice] := False;
    ProbarCombinacion(indice + 1);
  end;

begin
  // Inicializar los arrays para la mejor combinaci�n y la combinaci�n actual
  SetLength(MejorCombinacion, Length(Objetos));
  SetLength(CombinacionActual, Length(Objetos));
  MejorBeneficio := 0;
  // Comenzar la exploraci�n de combinaciones desde el primer objeto
  ProbarCombinacion(Low(Objetos));

  // Imprimir la mejor combinaci�n encontrada
  WriteLn('Mejor combinaci�n de objetos para la mochila:');
  for i := Low(Objetos) to High(Objetos) do
    if MejorCombinacion[i] then
      WriteLn('Objeto[', Objetos[i].ID, '] con peso: ', Objetos[i].Peso, ', beneficio: ', Objetos[i].Beneficio);
  WriteLn('Beneficio total: ', MejorBeneficio);
end;

















// ===== MAIN =====
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
    2: FuerzaBruta(MochilaMaxPeso, Objetos);
    //3: Backtracking;
  else
    WriteLn('Opci�n no v�lida.');
  end;

  ReadLn;
end.
