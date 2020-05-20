CREATE TABLE [dbo].[EstadoVariacionHacienda] (
    [Cuenta]     NVARCHAR (50)  NOT NULL,
    [CuentaD]    NVARCHAR (300) NOT NULL,
    [Nivel]      INT            NOT NULL,
    [Naturaleza] CHAR (1)       NOT NULL,
    [Saldo]      MONEY          NOT NULL,
    [Anio]       INT            NOT NULL,
    [Mes]        INT            NOT NULL,
    [Ejercicio]  INT            NOT NULL,
    [Municipio]  NVARCHAR (200) NOT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoVariacionHacienda_Municipio]
    ON [dbo].[EstadoVariacionHacienda]([Municipio] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoVariacionHacienda_Municipio_Mes]
    ON [dbo].[EstadoVariacionHacienda]([Municipio] ASC, [Mes] ASC);

