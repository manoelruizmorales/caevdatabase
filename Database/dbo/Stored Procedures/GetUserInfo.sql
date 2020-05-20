


create PROCEDURE [dbo].[GetUserInfo] 
	-- Add the parameters for the stored procedure here
	@UserName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	   [id]      
      ,[password]     
      ,[login]
      ,[UserNameActiveDirectory]
	  ,[ValidateWithActiveDirectory]
  FROM [dbo].[USUARIOS] where [login]=@UserName

END
