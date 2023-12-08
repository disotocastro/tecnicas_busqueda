 program Metodos_Busqueda;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  Mochila,
  Viajero in 'Viajero.pas';

// Asumiendo que todos los procedimientos y funciones se movieron aqu�


{ MENU MOCHILA }
procedure ProblemaMochila;
var
  MochilaMaxPeso, i: Integer;
  peso, beneficio: array of Integer;
  Lista: TStringList;
  opcionMenu: Integer;
  Objetos: array of TObjeto;
begin
  // Solicitar el peso m�ximo de la mochila
  WriteLn('');
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

  while True do
  begin
    // Imprimir el men�
    WriteLn('');
    WriteLn('Selecciona el algoritmo de b�squeda:');
    WriteLn('1 - Greedy');
    WriteLn('2 - Fuerza bruta (Exhaustiva pura)');
    WriteLn('3 - Backtracking (B�squeda Exhaustiva con Ramificaci�n y Acotamiento)');
    WriteLn('4 - Salir');
    Write('Opci�n: ');
    ReadLn(opcionMenu);
    WriteLn('');

    case opcionMenu of
//      1: Greedy(MochilaMaxPeso, Objetos);
      2: FuerzaBruta(MochilaMaxPeso, Objetos);
      3: Backtracking(MochilaMaxPeso, Objetos);
      4: Break;  // Rompe el bucle while, saliendo del programa
    else
      WriteLn('Opci�n no v�lida.');
    end;
  end;
  ReadLn;
end;



{ MENU ASIGNACION }
procedure ProblemaAsignacion;
begin



end;

{ MENU DISTRIBUCION }
procedure ProblemaDistribucion;
begin



end;

{ MENU VENDEDOR }
procedure ProblemaVendedor;
begin

var
opcionMenu: Integer;

while True do
  begin
    // Imprimir el men�
    WriteLn('');
    WriteLn('Selecciona el algoritmo de b�squeda:');
    WriteLn('1 - Greedy');
    WriteLn('2 - Fuerza bruta (Exhaustiva pura)');
    WriteLn('3 - Backtracking (B�squeda Exhaustiva con Ramificaci�n y Acotamiento)');
    WriteLn('4 - Salir');
    Write('Opci�n: ');
    ReadLn(opcionMenu);
    WriteLn('');

      loadCities;  // Carga las ciudades
    case opcionMenu of
      1: greedy;      // Ejecuta el algoritmo greedy
      2: exhaustiva;  // Ejecuta la b�squeda exhaustiva
      3: branchAndBound;
      4: Break;  // Rompe el bucle while, saliendo del programa
    else
      WriteLn('Opci�n no v�lida.');
    end;
  end;
  ReadLn;

end;




{ MENU PRINCIPAL }
var
  opcionMenu: Integer;

begin
  repeat
    WriteLn('Selecciona el problema a resolver:');
    WriteLn('1) Problema de asignaci�n 1 a 1');
    WriteLn('2) Problema de distribuci�n de un recurso');
    WriteLn('3) Problema de la mochila');
    WriteLn('4) Problema del vendedor');
    WriteLn('5) Salir');
    Write('Opci�n: ');
    ReadLn(opcionMenu);

    case opcionMenu of
      //1: ProblemaAsignacion;
      //2: ProblemaDistribucion;
      3: ProblemaMochila;
      4: ProblemaVendedor;
      //5: WriteLn('Saliendo del programa...');
    else
      WriteLn('Opci�n no v�lida. Intente de nuevo.');
    end;

  until opcionMenu = 5;
end.
