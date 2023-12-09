unit Asignacion;

interface

uses
  System.SysUtils;

type
  TTablaGanancias = array of array of Integer;

// Exportar las funciones y procedimientos que ser�n accesibles desde otros archivos
function LeerTablaGanancias(N: Integer): TTablaGanancias;
procedure ImprimirTabla_Asignacion(const Tabla: TTablaGanancias);
procedure GreedyAsignacion(const Tabla: TTablaGanancias);
procedure FuerzaBruta_Asignacion(const Tabla: TTablaGanancias);
procedure BranchAndBoundAsignacion(const Tabla: TTablaGanancias);

implementation


// Funci�n para leer la tabla de ganancias de tama�o N x N de la entrada del usuario.
function LeerTablaGanancias(N: Integer): TTablaGanancias;
var
  i, j: Integer;
begin
  // Ajustar el tama�o de la matriz din�mica para que tenga N filas y N columnas.
  SetLength(Result, N, N);
  // Bucle para leer las ganancias de cada par de elementos.
  for i := 0 to N - 1 do
  begin
    for j := 0 to N - 1 do
    begin
      // Solicita al usuario que ingrese la ganancia de asignar el elemento i al elemento j.
      Write('Ingrese la ganancia para asignar el elemento ', i + 1, ' al elemento ', j + 1, ': ');
      // Lee la ganancia ingresada por el usuario y la almacena en la matriz.
      Readln(Result[i][j]);
    end;
  end;
end;

procedure ImprimirTabla_Asignacion(const Tabla: TTablaGanancias);
var
  i, j: Integer;
begin
  Writeln('Tabla de ganancias:');
  Writeln('              Ganancias');

  // Bucle para imprimir cada fila de la tabla.
  for i := Low(Tabla) to High(Tabla) do
  begin
    // Imprime el identificador del elemento de la fila.
    Write('Elemento ', i + 1, ': ');
    // Bucle para imprimir las ganancias de cada elemento en la fila.
    for j := Low(Tabla[i]) to High(Tabla[i]) do
    begin
      Write(Tabla[i][j]:4);
    end;

    Writeln;
  end;
end;


procedure GreedyAsignacion(const Tabla: TTablaGanancias);
var
  i, j, MaxJ, MaxGanancia: Integer;
  Asignacion: array of Integer; // Almacena el �ndice j asignado a cada elemento i
  Usado: array of Boolean;      // Marca si un elemento j ya ha sido asignado
begin
  SetLength(Asignacion, Length(Tabla));
  SetLength(Usado, Length(Tabla));

  for i := Low(Tabla) to High(Tabla) do
  begin
    MaxGanancia := -1; // Inicializa la m�xima ganancia con un valor imposible
    MaxJ := -1;        // Inicializa el �ndice de la m�xima ganancia

    for j := Low(Tabla[i]) to High(Tabla[i]) do
    begin
      // Busca la ganancia m�xima no asignada para el elemento i
      if (Tabla[i][j] > MaxGanancia) and not Usado[j] then
      begin
        MaxGanancia := Tabla[i][j];
        MaxJ := j;
      end;
    end;

    // Si se encontr� una asignaci�n, la marca como usada y guarda la asignaci�n
    if MaxJ <> -1 then
    begin
      Asignacion[i] := MaxJ;
      Usado[MaxJ] := True;
    end;
  end;

  // Imprime los resultados de la asignaci�n
  Writeln('Resultado de la asignaci�n Greedy:');
  for i := Low(Asignacion) to High(Asignacion) do
  begin
    if Asignacion[i] <> -1 then
      Writeln('Elemento ', i + 1, ' asignado a ', Asignacion[i] + 1, ' con ganancia: ', Tabla[i][Asignacion[i]])
    else
      Writeln('Elemento ', i + 1, ' no se pudo asignar.');
  end;
end;


// FUERZA BRUTA
procedure FuerzaBruta_Asignacion(const Tabla: TTablaGanancias);
var
  MejorGanancia: Integer;
  MejorAsignacion, ActualAsignacion: array of Integer;
  i, TotalPermutaciones: Integer;

  procedure ProbarPermutacion(indice: Integer; GananciaActual: Integer);
  var
    j, Temp: Integer;
  begin
    if indice = Length(Tabla) then
    begin
      if GananciaActual > MejorGanancia then
      begin
        MejorGanancia := GananciaActual;
        MejorAsignacion := Copy(ActualAsignacion);
      end;

      // Incrementar el conteo de permutaciones cada vez que se completa una
      Inc(TotalPermutaciones);

      Exit;
    end;

    for j := indice to High(Tabla) do
    begin
      // Realiza una permutaci�n de los �ndices
      Temp := ActualAsignacion[indice];
      ActualAsignacion[indice] := ActualAsignacion[j];
      ActualAsignacion[j] := Temp;

      // Llamada recursiva con el siguiente �ndice y la ganancia actualizada
      ProbarPermutacion(indice + 1, GananciaActual + Tabla[indice][ActualAsignacion[indice]]);

      // Revertir la permutaci�n para continuar con el siguiente ciclo
      Temp := ActualAsignacion[indice];
      ActualAsignacion[indice] := ActualAsignacion[j];
      ActualAsignacion[j] := Temp;
    end;
  end;

begin
  SetLength(MejorAsignacion, Length(Tabla));
  SetLength(ActualAsignacion, Length(Tabla));
  MejorGanancia := -MaxInt; // Inicializar con el peor caso
  TotalPermutaciones := 0;  // Inicializar el contador de permutaciones

  // Asignaci�n inicial en orden
  for i := Low(Tabla) to High(Tabla) do
    ActualAsignacion[i] := i;

  ProbarPermutacion(0, 0);

  // Imprimir la mejor asignaci�n y el total de permutaciones
  Writeln('Resultado de la asignaci�n por Fuerza Bruta:');
  for i := Low(MejorAsignacion) to High(MejorAsignacion) do
    Writeln('Elemento ', i + 1, ' asignado a ', MejorAsignacion[i] + 1,
            ' con ganancia: ', Tabla[i][MejorAsignacion[i]]);
  Writeln('Total de permutaciones probadas: ', TotalPermutaciones);
end;







procedure BranchAndBoundAsignacion(const Tabla: TTablaGanancias);
var
  MejorGanancia: Integer;
  MejorAsignacion, ActualAsignacion: array of Integer;
  Usado: array of Boolean;
  i: Integer;

  function CalcularGananciaMaximaPosible(indice: Integer; GananciaActual: Integer): Integer;
  var
    i, j, GananciaMaxima: Integer;
  begin
    Result := GananciaActual;
    for j := indice to High(Tabla) do
    begin
      GananciaMaxima := -MaxInt;
      // Encuentra la m�xima ganancia posible para el elemento j no usado.
      for i := Low(Tabla[j]) to High(Tabla[j]) do
        if not Usado[i] and (Tabla[j][i] > GananciaMaxima) then
          GananciaMaxima := Tabla[j][i];
      if GananciaMaxima > 0 then
        Inc(Result, GananciaMaxima);
    end;
  end;

  procedure Buscar(indice: Integer; GananciaActual: Integer);
  var
    j: Integer;
  begin
    if indice = Length(Tabla) then
    begin
      if GananciaActual > MejorGanancia then
      begin
        MejorGanancia := GananciaActual;
        MejorAsignacion := Copy(ActualAsignacion);
      end;
      Exit;
    end;

    for j := Low(Tabla[indice]) to High(Tabla[indice]) do
    begin
      if not Usado[j] then
      begin
        Usado[j] := True;
        ActualAsignacion[indice] := j;

        // Antes de continuar con la b�squeda, verifica si es posible alcanzar una ganancia mayor.
        if CalcularGananciaMaximaPosible(indice + 1, GananciaActual + Tabla[indice][j]) > MejorGanancia then
          Buscar(indice + 1, GananciaActual + Tabla[indice][j]);

        Usado[j] := False;
      end;
    end;
  end;

begin
  SetLength(MejorAsignacion, Length(Tabla));
  SetLength(ActualAsignacion, Length(Tabla));
  SetLength(Usado, Length(Tabla));
  FillChar(Usado[0], Length(Usado), 0);
  MejorGanancia := -MaxInt;

  Buscar(0, 0);

  Writeln('Resultado de la asignaci�n por Branch and Bound:');
  for i := Low(MejorAsignacion) to High(MejorAsignacion) do
    Writeln('Elemento ', i + 1, ' asignado a ', MejorAsignacion[i] + 1,
            ' con ganancia: ', Tabla[i][MejorAsignacion[i]]);
end;



// MAIN
var
  N: Integer;
  TablaGanancias: TTablaGanancias;
end.
