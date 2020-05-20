CREATE TABLE [dbo].[Balanza] (
    [Cuenta]       NVARCHAR (50)  NOT NULL,
    [Nivel]        INT            NOT NULL,
    [CuentaD]      NVARCHAR (300) NOT NULL,
    [SaldoInicial] MONEY          NOT NULL,
    [Cargo]        MONEY          NOT NULL,
    [Abono]        MONEY          NOT NULL,
    [SaldoFinal]   MONEY          NOT NULL,
    [Mes]          INT            NOT NULL,
    [Ejercicio]    INT            NOT NULL,
    [Municipio]    NVARCHAR (200) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_Balanza_Cuenta]
    ON [dbo].[Balanza]([Cuenta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Balanza_Municipio_Mes]
    ON [dbo].[Balanza]([Municipio] ASC, [Mes] ASC) WITH (FILLFACTOR = 90);

