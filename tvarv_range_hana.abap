** aqui estamos considerando uma tvarv criada anteriormente
** com os tipos de materiais que iremos excluir.


DATA:  lr_range         TYPE RANGE OF tvarvc-low, "" range de tipos de materiais
       LR_EXCLUDE_MATNR TYPE RANGE OF mara-matnr. "" aqui temos um range para exclusão
       
    
       select werks, matnr, budat, cpudt, cputm
              bwart sum ( erfmg ) as qtde
          from matdoc
          where mblnr in @s_mblnr
          and werks in @s_werks
          and matnr in @s_matnr
          and lgort in @s_lgort
          and budat in @s_budat
          and cpudt in @s_cpudt
          and cputm in @s_cputm
          and bwart in @s_bwart
        group by werks, matnr, budat, cpudt, cputm, bwart
        order by werks, cpudt, cputm, matnr
        into table @data(gt_movimentos_estoque).
  
** acima podemos ver uma tabela interna sendo criada "in-line"  e sendo "preenchida"     

select sign opti low high
    from tvarvc
    into tabela lr_range
    where name = 'ZMM_EXCLUD'.
* O Select acima busca uma tvarv pelo nome e insere no range de tipos de materiais

 if sy-subrc is initial and gt_movimentos_estoque[] is not initial.
* a condição acima verifica que se a tvarv foi encontrada e se a tabela interna gt_movimento_estoque contem ítem
*sendo assim segue para o select abaixo.     
    select matnr, mtart
        from mara
        into table @data(lt_mara)
        for all entries in @gt_movimentos_estoque
        where matnr eq @gt_movimentos_estoque-matnr
        and mtart in @lr_range.
* o select busca materiais na MARA e insere na LT_MARA desde que sejam iguais aos que constam na gt_movimentos_estoque
* e que tenha o tipo do material que consta na tvarv. 
        if sy-subrc is initial.
            lr_exclude_matnr = VALUE #( FOR <FS_MAT> IN lt_mara[] 
                                       ( sign = 'I'
                                        option = 'EQ'
                                        low = <FS_MAT>-MATNR
                                        high = ''
                                        )).
* a condição acima verifica e segue se for atendida.
*a instrução após a condição está pegando o material exato que atende o requisito da tvarv e inserindo no range de exclusão.
          delete gt_movimentos_estoque where matnr in lr_exclude_matnr.                              
* o delete exclui da tabela interna apenas os materiais que estiveram no range de exclusão.          
        endif.

endif.