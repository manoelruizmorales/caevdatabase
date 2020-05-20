

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--
-- Parameters:
--   @nombre
--   @apellido
--   @login - nombre de usuario en ActiveDirectory
--   @UserNameActiveDirectory - nombre de usuario en ActiveDirectory
--   @validateWithActiveDirectory - true: valida acceso desde ActiveDirectory, false: valida acceso desde base de datos
-- =============================================
create PROCEDURE [dbo].[spUpdateUsuario]

	-- Add the parameters for the stored procedure here
	 @UsuarioID int
	,@nombre nvarchar(200)
	,@apellido nvarchar(200)
	,@login nvarchar(20)
	,@UserNameActiveDirectory nvarchar(200)
	,@validateWithActiveDirectory bit		

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	Update dbo.USUARIOS 
	SET 
	    nombre=@nombre
	   ,apellido=@apellido
	   ,[login]=@login
	   ,UserNameActiveDirectory=@UserNameActiveDirectory
	   ,ValidateWithActiveDirectory=@validateWithActiveDirectory
	WHERE id=@UsuarioID	
	
		
END
