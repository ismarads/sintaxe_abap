*----------------------------------------------------*
*  comandos opens sql no abap
*  para a execução de report se faz necessário a 
*   criação de uma tabela com os campos tpmat e denominação
*  esse report tem como finalidade a prática dos comandos
*insert - para inserir dados numa tabela
*update -  para atualizar dados numa tabela 
*modify - para modificar ou criar dados numa tabela
*delete - para deletar dados numa tabela
*----------------------------------------------------------*

REPORT zsql_ism.



TABLES zt0001.

PARAMETERS: p_tpmat  LIKE zt0001-tpmat OBLIGATORY,
            p_denom  LIKE zt0001-denom OBLIGATORY,
            p_insert RADIOBUTTON GROUP gr1,
            p_update RADIOBUTTON GROUP gr1,
            p_modify RADIOBUTTON GROUP gr1,
            p_delete RADIOBUTTON GROUP gr1.


* inserindo

IF p_insert = 'X'.
  CLEAR zt0001.
  zt0001-tpmat = p_tpmat.
  zt0001-denom = p_denom.
  INSERT zt0001.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'Dados inseridos com sucesso' TYPE 'S'.

  ELSE.
    ROLLBACK WORK.
    MESSAGE 'Dados  não inseridos ' TYPE 'I'.
  ENDIF.


* ATUALIZANDO DADOS DA TABELA

ELSEIF p_update = 'X'.

  UPDATE zt0001
    SET denom = p_denom
   WHERE tpmat = p_tpmat.


  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'dados atualizados com sucesso'  TYPE 'S'.

  ELSE.
    ROLLBACK WORK.
    MESSAGE 'erro ao atualizar' TYPE 'I'.

  ENDIF.

* MODIFY

ELSEIF p_modify = 'X'.
  CLEAR zt0001.
  zt0001-tpmat = p_tpmat.
  zt0001-denom = p_denom.
  MODIFY zt0001.
  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'dados MODIFICADOS com sucesso'  TYPE 'S'.

  ELSE.
    ROLLBACK WORK.
    MESSAGE 'erro ao MODIFICAR' TYPE 'I'.

  ENDIF.

*DELETANDO

ELSEIF p_delete = 'X'.
  DELETE FROM zt0001 WHERE tpmat = p_tpmat.

  IF sy-subrc = 0.
    COMMIT WORK.
    MESSAGE 'dados DELETADOS com sucesso'  TYPE 'S'.

  ELSE.
    ROLLBACK WORK.
    MESSAGE 'erro TENTAR DELETAR' TYPE 'I'.

  ENDIF.

ENDIF.
