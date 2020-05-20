

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--
-- Parameters:
--   @UsuarioID - nombre de usuario en ActiveDirectory

-- =============================================
create PROCEDURE [dbo].[spDeleteUsuario]

	-- Add the parameters for the stored procedure here	
	@UsuarioID 	int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	delete from [AuditoriaSigmaver2019].[dbo].UsuarioEnte where UsuarioID=@UsuarioID
	delete from [AuditoriaSigmaver2019].[dbo].Usuario_Seguridad where id_usuario=@UsuarioID
	delete from [AuditoriaSigmaver2019].[dbo].Auditoria where usuario=@UsuarioID
	delete from [AuditoriaSigmaver2019].[dbo].USUARIOS where id=@UsuarioID

	delete from [AuditoriaSigmaver2018Cierre].[dbo].UsuarioEnte where UsuarioID=@UsuarioID
	delete from [AuditoriaSigmaver2018Cierre].[dbo].Usuario_Seguridad where id_usuario=@UsuarioID
	delete from [AuditoriaSigmaver2018Cierre].[dbo].Auditoria where usuario=@UsuarioID
	delete from [AuditoriaSigmaver2018Cierre].[dbo].USUARIOS where id=@UsuarioID

	delete from [AuditoriaSigmaver].[dbo].UsuarioEnte where UsuarioID=@UsuarioID
	delete from [AuditoriaSigmaver].[dbo].Usuario_Seguridad where id_usuario=@UsuarioID
	delete from [AuditoriaSigmaver].[dbo].Auditoria where usuario=@UsuarioID
	delete from [AuditoriaSigmaver].[dbo].USUARIOS where id=@UsuarioID

	
END

