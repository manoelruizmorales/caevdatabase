-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION spfncGetMenu
(	
	-- Add the parameters for the function here
	@mes as int
	
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here

	SELECT cast(@mes as nvarchar(5))Mes
)