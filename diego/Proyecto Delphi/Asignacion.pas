unit Asignacion;

interface

uses
  Classes, SysUtils;

type
  TTablaGanancias = array of array of Integer;

function LeerTablaGanancias(N: Integer): TTablaGanancias;
procedure ImprimirTabla(const Tabla: TTablaGanancias);

implementation

// Función para leer la tabla de ganancias de tamaño N x N
function LeerTablaGanancias(N: Integer): TTablaGanancias;
var
  i, j: Integer;
begin
  SetLength(Result, N, N); // Ajustar el tamaño de la matriz
  for i := 0 to N - 1 do
  begin
    for j := 0 to N - 1 do
    begin
      Write('Ingrese la ganancia para asignar el elemento ', i + 1, ' al elemento ', j + 1, ': ');
      Readln(Result[i][j]);
    end;
  end;
end;

// Procedimiento para imprimir la tabla de ganancias
procedure ImprimirTabla(const Tabla: TTablaGanancias);
var
  i, j: Integer;
begin
  for i := Low(Tabla) to High(Tabla) do
  begin
    for j := Low(Tabla[i]) to High(Tabla[i]) do
    begin
      Write(Tabla[i][j]:8); // Formatear la salida para una mejor visualización
    end;
    Writeln;
  end;
end;

end.

