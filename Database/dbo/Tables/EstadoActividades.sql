CREATE TABLE [dbo].[EstadoActividades] (
    [Cuenta]                 NVARCHAR (50)  NOT NULL,
    [CuentaD]                NVARCHAR (300) NOT NULL,
    [Nivel]                  INT            NOT NULL,
    [Naturaleza]             CHAR (1)       NOT NULL,
    [SaldoEjercicioAnterior] MONEY          NOT NULL,
    [SaldoEjercicioActual]   MONEY          NOT NULL,
    [Mes]                    INT            NOT NULL,
    [Ejercicio]              INT            NOT NULL,
    [Municipio]              NVARCHAR (200) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoActividades_Cuenta]
    ON [dbo].[EstadoActividades]([Cuenta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoActividades_Municipio_Mes]
    ON [dbo].[EstadoActividades]([Municipio] ASC, [Mes] ASC) WITH (FILLFACTOR = 90);

