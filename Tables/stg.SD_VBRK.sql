CREATE TABLE [stg].[SD_VBRK] (
  [FACTURA] [int] NULL,
  [CLASEFACTURA] [varchar](50) NULL,
  [TIPOFACTURA] [varchar](50) NULL,
  [TIPODOCCOMERCIAL] [varchar](50) NULL,
  [MONEDA] [varchar](50) NULL,
  [ORGVENTAS] [int] NULL,
  [CANALDIST] [int] NULL,
  [NROCONDICION] [int] NULL,
  [FECHAFACTURA] [datetime2] NULL,
  [CONDPAGO] [varbinary](max) NULL,
  [SOCIEDAD] [int] NULL,
  [VALORNETO] [float] NULL,
  [HORA] [datetime2] NULL,
  [CLIENTEPAGADOR] [varchar](50) NULL,
  [SOLICITANTE] [varchar](50) NULL,
  [REFERENCIA] [varchar](50) NULL,
  [IMPORTEIMPUESTO] [float] NULL,
  [REFERENCIAPAGO] [int] NULL
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', 'Documentos con alguna linea que tenga material = 12000000140', 'SCHEMA', N'stg', 'TABLE', N'SD_VBRK'
GO