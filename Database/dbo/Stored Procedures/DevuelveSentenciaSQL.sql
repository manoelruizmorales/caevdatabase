


CREATE PROCEDURE [dbo].[DevuelveSentenciaSQL]
	@tabla varchar(100), 
	@id_Usuario int
AS
BEGIN
declare
@sentencia nvarchar(max),
@condicion nvarchar(max),
@condicion2 nvarchar(max),
@condicion3 nvarchar(max),
@inicia varchar(5),
@agrega1 varchar(5),
@agrega2 varchar(5),
@contador int,
@contador1 int,
@contador2 int,
      @tipo_Catalogo nchar(1)=
(
    SELECT TOP 1 tipo
    FROM Catalogos_Sistema
    WHERE catalogo = @tabla
),@campo varchar(20)=
(
    SELECT TOP 1 campoRango
    FROM Catalogos_Sistema
    WHERE catalogo = @tabla
);
set @sentencia = 'Select * from '+@tabla+' where ';
set @condicion = '';
set @condicion2 = '';
set @condicion3 = '';

DECLARE valores CURSOR
             FOR
(
   select  valor,
           tipo_rango,
           inicial,
		 final 
     from fnc_DevuelveQuerySeguridad(@tabla,@id_Usuario)
);
             DECLARE @valor nVARCHAR(max), @tipo_rango nCHAR(1), @inicial nvarCHAR(max), @final nvarCHAR(max);
            -- SET NOCOUNT ON;
             OPEN valores;
             FETCH NEXT FROM valores INTO @valor, @tipo_rango, @inicial, @final;
             SET @contador =0;
             SET @contador2 =0;
             SET @contador1 =0;
		  
             WHILE @@fetch_status = 0
                 BEGIN
			    
			     if upper(@tipo_Catalogo) = 'R'
				     begin
						 --   print(@tipo_rango);
						    if @tipo_rango = 'I'
						      begin
							   if @contador1 = 0
							     set @agrega1 = '('
								else set @agrega1 = ' or ';
								set @contador1 = 1;
                                        set  @condicion = (@condicion+@agrega1+@campo+' between '+char(39)+@inicial+char(39)+' and '+char(39)+@final+char(39) );
								--print(@condicion);
							  end                         
                                   else 
				               if @tipo_rango = 'E'
						       begin
						     	if @contador2 = 0
							         set @agrega2 = '('
								  else set @agrega2 = ' and ';
								  set @contador2 = 1;
	                                   set  @condicion2 = (@condicion2+@agrega2+@campo+'  not between '+char(39)+@inicial+char(39)+' and '+char(39)+@final+char(39) );
				                 end 
				       end
				      else 
					   begin
					             if @contador1 = 0
							     set @agrega1 = '('
								else set @agrega1 = ' or ';
								set @contador1 = 1;
                                        set  @condicion = (@condicion+@agrega1+@campo+' = '+char(39)+@valor+char(39));
					   end; 

                     FETCH NEXT FROM valores INTO @valor, @tipo_rango, @inicial, @final;
                 END;
             CLOSE valores;
             DEALLOCATE valores; 
		   
		   if  @condicion2 <>''
		     set @condicion2 = (@condicion2+')');

              if  @condicion <>''
		     set @condicion =( @condicion+')');
	 if  (@condicion <>'' and  @condicion2 <>'')
	    set @condicion3 = 'and';
	   
		    if upper(@tipo_Catalogo) = 'R'		      
		      set @sentencia=(@sentencia+@condicion+@condicion3+@condicion2)
			 else  set @sentencia=( @sentencia +@condicion+')');
	     
	--	print(@sentencia); 
	--	print(upper(@tipo_Catalogo));
	--	print(upper(@condicion));
	--	print(upper(@condicion2));
		exec(@sentencia);
	
END

