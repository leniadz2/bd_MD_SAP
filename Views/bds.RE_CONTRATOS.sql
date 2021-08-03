SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [bds].[RE_CONTRATOS]
AS
/* Tablas de RE para obtener el RUC, gafo, subgafo por cada contrato
   -----------------------------------------------------------------
   Usar con ORDINTERLOCCOMERCIAL = 1
*/
SELECT
  RE_DFKKBPTAXNUM.[N.I.F.] AS NIF
 ,RE_VICNCN.Sociedad AS SOCIEDAD
 ,RE_VICNCN.Contrato AS CONTRATO
 ,RE_VIBPOBJREL.[Clave RE] AS CLAVE_RE
 ,RE_VIBPOBJREL.[Inicio relación] AS INI_RELACION
 ,RE_VIBPOBJREL.[Final relación] AS FIN_RELACION
 ,ROW_NUMBER() OVER (PARTITION BY RE_VIBPOBJREL.[Clave RE] ORDER BY RE_VIBDRO.[Clase de uso] ASC, RE_VIBPOBJREL.[Final relación] DESC) AS ORDINTERLOCCOMERCIAL
 ,RE_VICNCN.[Denominación de contrato] AS DEN_CONTRATO
 ,RE_VICNCN.[Inicio contrato] AS INI_CONTRATO
 ,RE_VICNCN.[Fin per.vigencia] AS FIN_CONTRATO
 ,CONCAT(SUBSTRING(RE_VICNCN.[Inicio contrato], 7, 4), '-', SUBSTRING(RE_VICNCN.[Inicio contrato], 1, 2), '-', SUBSTRING(RE_VICNCN.[Inicio contrato], 4, 2)) AS INI_CONTRATO_MOD
 ,CONCAT(SUBSTRING(RE_VICNCN.[Fin per.vigencia], 7, 4), '-', SUBSTRING(RE_VICNCN.[Fin per.vigencia], 1, 2), '-', SUBSTRING(RE_VICNCN.[Fin per.vigencia], 4, 2)) AS FIN_CONTRATO_MOD
 ,RE_VIBDRO.[Denom.obj.alquiler] AS OBJALQUILER
 ,RE_TIV0A.[Clase uso de unidad alquiler] AS CLASEUSO
 ,RE_VIBDRO.[Function Name] AS FUNCION
 ,CONCAT(RE_VIBDROOCC.[Unidad económica], ' - ', RE_VICNCN.[Denominación de contrato], ' - ', RE_VIBDRO.[Denom.obj.alquiler]) AS NOMCOMERCIAL
 ,IIF(CONVERT(VARCHAR, GETDATE(), 23) > CONCAT(SUBSTRING(RE_VICNCN.[Fin per.vigencia], 7, 4), '-', SUBSTRING(RE_VICNCN.[Fin per.vigencia], 1, 2), '-', SUBSTRING(RE_VICNCN.[Fin per.vigencia], 4, 2)), 'VENCIDO', 'VIGENTE') AS VIGCONTRATO
 ,RE_TB038A.FATHER_SEC AS COD_GAFO
 ,(SELECT
      a.TEXT
    FROM stg.RE_TB038A AS a
    WHERE a.IND_SECTOR = RE_TB038A.FATHER_SEC
    AND a.istype = 'ZRE1')
  AS GAFO
 ,RE_TB038A.IND_SECTOR AS COD_SUBGAFO
 ,RE_TB038A.TEXT AS SUBGAFO
FROM stg.RE_VIBPOBJREL
INNER JOIN stg.RE_VICNCN
  ON RE_VIBPOBJREL.[Clave RE] = RE_VICNCN.[Clave RE]
INNER JOIN stg.RE_DFKKBPTAXNUM
  ON RE_DFKKBPTAXNUM.[Interloc.comercial] = RE_VIBPOBJREL.[Interloc.comercial]
INNER JOIN stg.RE_TB038A
  ON RE_VICNCN.[Sector Industrial] = RE_TB038A.IND_SECTOR
INNER JOIN stg.RE_VIBDROOCC
  ON RE_VIBDROOCC.[Sociedad de contrato] = RE_VICNCN.Sociedad
    AND RE_VIBDROOCC.[Nº contrato] = RE_VICNCN.Contrato
INNER JOIN stg.RE_VIBDRO
  ON RE_VIBDRO.[Clave RE] = RE_VIBDROOCC.[Objeto de alquiler]
INNER JOIN stg.RE_TIV0A
  ON RE_TIV0A.[Clase de uso] = RE_VIBDRO.[Clase de uso]
WHERE RE_VIBPOBJREL.Función = 'TR0600'
AND RE_TB038A.istype = 'ZRE1'
AND RE_VIBDRO.[Function] NOT IN ('FN04' --depósito
, 'FN17')--zona de mesas
AND RE_VIBDRO.[Clase de uso] NOT IN ('20' --publicidad fija
, '21' --publicidad movil
, '22' -- activacion
, '23')--totem
AND RE_TIV0A.[Clave de idioma] = 'ES'
AND RE_VICNCN.Contrato NOT LIKE '3%' --contratos espacios publicitarios
GO