

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- :	<Description,,>
--Description
-- Parameters:
--   @nombre
--   @apellido
--   @login - nombre de usuario en ActiveDirectory
--   @password 
--   @UserNameActiveDirectory - nombre de usuario en ActiveDirectory
--   @validateWithActiveDirectory - true: valida acceso desde ActiveDirectory, false: valida acceso desde base de datos
--   @idSeguridadUsuarioMenu - id de tabla Seguridad_Usuario, correspondiente a reglas del catalogo Menu.Valor default 2 es para analistas
--   @idSeguridadUsuarioEntes - id de tabla Seguridad_Usuario, correspondiente a reglas del catalogo Entes.Valor default 7 es para analistas
-- =============================================
CREATE PROCEDURE [dbo].[spCrearUsuario]

	-- Add the parameters for the stored procedure here
	 @nombre nvarchar(200)
	,@apellido nvarchar(200)	
	,@login nvarchar(20)
	,@password nvarchar(20)
	,@UserNameActiveDirectory nvarchar(200)
	,@validateWithActiveDirectory bit	
	,@idSeguridadUsuarioMenu int=2
	,@idSeguridadUsuarioEntes int=7

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;		

    -- Insert statements for procedure here

	declare @newUserId int

	INSERT INTO [dbo].[USUARIOS]
           ([nombre]
           ,[apellido]
           ,[password]
           ,[padre]
           ,[login]
           ,[UserNameActiveDirectory]
		   ,[ValidateWithActiveDirectory])
     VALUES
           (@nombre
           ,@apellido
           ,@password
           ,2
           ,@login
           ,@UserNameActiveDirectory
		   ,@validateWithActiveDirectory)


	set @newUserId=@@IDENTITY

	INSERT INTO [dbo].[Usuario_Seguridad]
			   ([id_usuario]
			   ,[id_seguridad_usuario])
    
	select @newUserId,@idSeguridadUsuarioMenu
	union 
	select @newUserId,@idSeguridadUsuarioEntes		
		

	
END

