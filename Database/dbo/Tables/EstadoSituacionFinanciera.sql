CREATE TABLE [dbo].[EstadoSituacionFinanciera] (
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
CREATE NONCLUSTERED INDEX [IX_EstadoSituacionFinanciera_Cuenta]
    ON [dbo].[EstadoSituacionFinanciera]([Cuenta] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_EstadoSituacionFinanciera_Municipio_Mes]
    ON [dbo].[EstadoSituacionFinanciera]([Municipio] ASC, [Mes] ASC);

