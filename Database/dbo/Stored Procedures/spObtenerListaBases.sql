


CREATE PROCEDURE [dbo].[spObtenerListaBases]	-- Add the parameters for the stored procedure here

	 @id_Usuario int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	declare @tabla nvarchar(100);		
	
	DECLARE @T TABLE
	(  
	  
	   baseDatos varchar(100),
	   idMunicipio int,
	   Vigencia int,
	   MunicipioID int
	);
		

	-- Reglas de seguridad con id=4 , corresponde a Catálogo de Municipios
	-- Verificamos si el usuario está referenciado en una de estas reglas de seguridad

	IF EXISTS (		SELECT 
						TOP 1 c.id
					FROM [Catalogos_Sistema]  c
					INNER JOIN [Seguridad_Usuario] s
					INNER JOIN [Usuario_Seguridad] us
					ON us.id_seguridad_usuario=s.id
					ON c.id=s.catalogo  
					WHERE c.id=4 and us.id_usuario=@id_Usuario )  
	BEGIN
	  	
	  set @tabla =  (select catalogo from Catalogos_Sistema where id=4)
	  Insert @T Exec [DevuelveSentenciaSQL]  @tabla,@id_Usuario

	END
	ELSE
	BEGIN

		-- Si el usuario no está referenciado en reglas de seguridad para catálogo de Municipios
		-- Obtenemos los entes permitidos en tabla UsuarioEnte
	
		 INSERT @T 

		 SELECT 
			 BDMunicipios.baseDatos
			,Municipios.CVE_MUN	
			,BDMunicipios.Vigencia
			,BDMunicipios.MunicipioID	
		 FROM BDMunicipios
		 LEFT JOIN Municipios
		 INNER JOIN UsuarioEnte 
		 ON UsuarioEnte.MunicipioID=Municipios.Id
		 ON Municipios.CVE_MUN=BDMunicipios.idmunicipio
		 WHERE UsuarioEnte.UsuarioID=@id_Usuario 

	END

	SELECT 
		 t1.baseDatos db
		,Municipios.[NOM_MUN] name
		,Municipios.TipoEnteID						
		--,CASE WHEN tbl.municipio IS NULL THEN 0 ELSE 1 END TieneObrasAdmonDirecta
		,IsNull(t1.Vigencia,0) Vigencia
	FROM Municipios 
	INNER JOIN @T t1
	ON t1.idmunicipio=Municipios.CVE_MUN
	--LEFT JOIN (SELECT [municipio] FROM [dbo].[Obra_DatosAD] GROUP BY  [municipio] ) tbl
	--ON tbl.municipio=t1.baseDatos
	ORDER BY db

	-- Asociamos con Obra_DatosAD para determinar si el ente tiene obras por administración directa

END

