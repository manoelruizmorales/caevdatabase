

CREATE PROCEDURE [dbo].[spGeneraEstadoAnaliticoActivo]
	-- Add the parameters for the stored procedure here
	@bd as nvarchar(200)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @sql nvarchar(max);	
	declare @ejercicioID as uniqueidentifier;
	declare @ejercicio as int;
	declare @mesNombre as nvarchar(50);
	declare @mesNumero as int;
	declare @enteID as uniqueidentifier;
	
	declare @tablaEstadoAnaliticoActivo table(

		[codigoCompleto] [nvarchar](50),
		[nombre] [nvarchar](300),
		[saldoInicial] [money],
		[cargos] [money],
		[abonos] [money],
		[saldoFinal] [money],
		[variacion] [money],
		[nivel] [int]

	)	
	

   set @sql=replace('select top 1 @ejercicioID=id,@ejercicio=anio from #tokend_db.dbo.Ejercicio','#tokend_db',@bd);  
	  
   exec sp_executesql @sql, N'@ejercicioID uniqueidentifier out,@ejercicio int out',@ejercicioID out , @ejercicio out	 

   set @sql=replace('select top 1 @enteID=id from #tokend_db.dbo.Ente','#tokend_db',@bd);
	  
   exec sp_executesql @sql, N'@enteID uniqueidentifier out',@enteID out 	


   set @mesNumero=1;
	
   while @mesNumero <= 12
   begin

        

	   set @mesNombre=
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

	   print 'INICIA PROCESO: ' +  @mesNombre;  	

	   set @sql=FormatMessage(
				 ' exec %s.dbo.analiticoDeActivos 
					    @mes=''%s''
					   ,@numMes=%d
					   ,@ejercicio=''%s''
					   ,@ente=''%s'' 
					   ',right(@bd,len(@bd)-charindex('.',@bd,0)),@mesNombre,@mesNumero,convert(nvarchar(50), @ejercicioID),convert(nvarchar(50), @enteID))
	


	  
	  
	  if(charindex('.',@bd,0)!=0) --nombre de la base contiene referencia a servidor vinculado 
	  begin

	   set @sql=FormatMessage(
				 ' exec %s.dbo.analiticoDeActivos 
				        @mes=''''%s''''
					   ,@numMes=%d
					   ,@ejercicio=''''%s''''
					   ,@ente=''''%s''''
					   ',right(@bd,len(@bd)-charindex('.',@bd,0)),@mesNombre,@mesNumero,convert(nvarchar(50), @ejercicioID),convert(nvarchar(50), @enteID))




	    set @sql=FormatMessage('SELECT * FROM OPENQUERY([BackupServer],''%s'')',@sql)

	  end 
	     	 

	  insert @tablaEstadoAnaliticoActivo exec(@sql)
	  
	

		insert into [dbo].[EstadoAnaliticoActivo]
           ([Cuenta]
           ,[CuentaD]
           ,[Nivel]
           ,[SaldoInicial]
           ,[Cargos]
           ,[Abonos]
           ,[SaldoFinal]
           ,[Variacion]
           ,[Mes]
           ,[Ejercicio]
           ,[Municipio])
	   
			    
		select
	
		   codigocompleto		  
		  ,nombre
		  ,nivel
		  ,saldoInicial
		  ,cargos
		  ,abonos
		  ,saldoFinal
		  ,variacion
		  ,@mesNumero		  
		  ,@ejercicio Ejercicio
		  ,right(@bd,len(@bd)-charindex('.',@bd,0)) Municipio	
	 
		from @tablaEstadoAnaliticoActivo			
		
	   delete @tablaEstadoAnaliticoActivo;  

	   set @mesNumero=@mesNumero + 1;

	  print 'TERMINA PROCESO: ' +  @mesNombre;      

   end   
	
END

