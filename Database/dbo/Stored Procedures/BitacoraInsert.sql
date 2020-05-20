

create PROCEDURE [dbo].[BitacoraInsert]
	-- Add the parameters for the stored procedure here	
	@usuarioId int,
	@proceso nvarchar(max),  
    @tipo int,
    @municipio nvarchar(max),
    @ip nvarchar(max)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET XACT_ABORT ON

    -- Insert statements for procedure here

	BEGIN TRANSACTION
	
	INSERT INTO [dbo].[Auditoria]
           ([usuario]
           ,[proceso]
           ,[fecha]
           ,[hora]
           ,[tipo]
           ,[municipio]
           ,[ip])
     VALUES
           (@usuarioId
           ,@proceso
           ,getdate()
           ,CONVERT (time, getdate()) 
           ,@tipo
           ,@municipio
           ,@ip)

	COMMIT


END


