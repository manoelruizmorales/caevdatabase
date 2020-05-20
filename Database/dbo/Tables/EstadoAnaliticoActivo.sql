CREATE TABLE [dbo].[EstadoAnaliticoActivo] (
    [Cuenta]       NVARCHAR (50)  NOT NULL,
    [CuentaD]      NVARCHAR (300) NOT NULL,
    [Nivel]        INT            NOT NULL,
    [SaldoInicial] MONEY          NOT NULL,
    [Cargos]       MONEY          NOT NULL,
    [Abonos]       MONEY          NOT NULL,
    [SaldoFinal]   MONEY          NOT NULL,
    [Variacion]    MONEY          NOT NULL,
    [Mes]          INT            NOT NULL,
    [Ejercicio]    INT            NOT NULL,
    [Municipio]    NVARCHAR (200) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoAnaliticoActivo_Municipio]
    ON [dbo].[EstadoAnaliticoActivo]([Municipio] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoAnaliticoActivo_Mes]
    ON [dbo].[EstadoAnaliticoActivo]([Mes] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoAnaliticoActivo_Municipio_Mes]
    ON [dbo].[EstadoAnaliticoActivo]([Municipio] ASC, [Mes] ASC);

