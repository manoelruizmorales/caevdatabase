

CREATE PROCEDURE [dbo].[spGeneraBalanza]
	-- Add the parameters for the stored procedure here
	@bd as nvarchar(200)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @sql nvarchar(max);	
	declare @idEjercicio as uniqueidentifier;
	declare @ejercicio as int;
	declare @mes as nvarchar(50);
	declare @mesNumero as int;
	declare @tipoRep nvarchar(5)='BC';
	declare @ente as uniqueidentifier;
	declare @hastaElMes as bit=0;
	declare @nivel as smallint=10;	


	declare @tablaBalanza table(

		id uniqueidentifier,
		nivel int,
		nombre nvarchar(MAX),
		saldoInicial decimal(18, 2),
		debe decimal(18, 2), 
		haber decimal(18, 2),
		esRegistro bit,
		sumTotalIninicial decimal(18, 2),
		sumTotalDebe decimal(18, 2), 
		sumTotalHaber decimal(18, 2),
		sumTotalFinal decimal(18, 2), 
		AhorroDesAhorro decimal(18, 2),
		naturaleza nchar(1),
		codigocompleto nvarchar(MAX), 
		super uniqueidentifier,
		nombreSinCodigo nvarchar(MAX),
		agrupador nvarchar(MAX),
		agrupadorPasivoHacienda nvarchar(MAX)

	)	
	

   set @sql=replace('select top 1 @idEjercicio=id,@ejercicio=anio from #tokend_db.dbo.Ejercicio','#tokend_db',@bd);
  
	  
   exec sp_executesql @sql, N'@idEjercicio uniqueidentifier out,@ejercicio int out',@idEjercicio out , @ejercicio out	 

   set @sql=replace('select top 1 @ente=id from #tokend_db.dbo.Ente','#tokend_db',@bd);
	  
   exec sp_executesql @sql, N'@ente uniqueidentifier out',@ente out 	


   set @mesNumero=1;
	
   while @mesNumero <= 12
   begin

        

	   set @mes=
	   case @mesNumero

	     when 1 then 'Enero'
		 when 2 then 'Febrero'
		 when 3 then 'Marzo'
		 when 4 then 'Abril'
		 when 5 then 'Mayo'
		 when 6 then 'Junio'
		 when 7 then 'Julio'
		 when 8 then 'Agosto'
		 when 9 then 'Septiembre'
		 when 10 then 'Octubre'
		 when 11 then 'Noviembre'
		 when 12 then 'Diciembre'
		 else ''

	   end

	   print 'INICIA PROCESO: ' +  @mes;  	

	   set @sql=FormatMessage(
				 ' exec %s.dbo.balanzaComprobacion 
					    @idEjercicio=''%s''
					   ,@mes=''%s''
					   ,@mesNumero=%d
					   ,@tipoRep=''%s''
					   ,@ente=''%s''
					   ,@hastaElMes=%d
					   ,@nivel=%d',right(@bd,len(@bd)-charindex('.',@bd,0)),convert(nvarchar(50), @idEjercicio),@mes,@mesNumero,@tipoRep,convert(nvarchar(50), @ente),convert(int,@hastaElMes),@nivel)
	


	  
	  
	  if(charindex('.',@bd,0)!=0) --nombre de la base contiene referencia a servidor vinculado 
	  begin

	   set @sql=FormatMessage(
				 ' exec %s.dbo.balanzaComprobacion 
					    @idEjercicio=''''%s''''
					   ,@mes=''''%s''''
					   ,@mesNumero=%d
					   ,@tipoRep=''''%s''''
					   ,@ente=''''%s''''
					   ,@hastaElMes=%d
					   ,@nivel=%d',right(@bd,len(@bd)-charindex('.',@bd,0)),convert(nvarchar(50), @idEjercicio),@mes,@mesNumero,@tipoRep,convert(nvarchar(50), @ente),convert(int,@hastaElMes),@nivel)




	    set @sql=FormatMessage('SELECT * FROM OPENQUERY([BackupServer],''%s'')',@sql)

	  end 
	     	 

	  insert @tablaBalanza exec(@sql)
	  
	

		insert into [dbo].[Balanza]
			([Cuenta]
			,[Nivel]
			,[CuentaD]
			,[SaldoInicial]
			,[Cargo]
			,[Abono]
			,[SaldoFinal]
			,[Mes]		
			,[Ejercicio]
			,[Municipio])  
	   
			    
		select
	
		   codigocompleto
		  ,nivel
		  ,nombreSinCodigo
		  ,saldoInicial
		  ,debe
		  ,haber
		  ,sumTotalFinal
		  ,@mesNumero		  
		  ,@ejercicio Ejercicio
		  ,right(@bd,len(@bd)-charindex('.',@bd,0)) Municipio	
	 
		from @tablaBalanza	
		
		
	   delete @tablaBalanza;  

	   set @mesNumero=@mesNumero + 1;

	  print 'TERMINA PROCESO: ' +  @mes;      

   end   
	
END
