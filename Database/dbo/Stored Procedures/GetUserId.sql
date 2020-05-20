
CREATE PROCEDURE [dbo].[GetUserId] 
	-- Add the parameters for the stored procedure here
	@userNameOnActiveDirectory nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [id] FROM [dbo].[USUARIOS] where [UserNameActiveDirectory]=@userNameOnActiveDirectory
END

