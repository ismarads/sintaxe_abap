REPORT zr_ism_updown.

""types

TYPES: BEGIN OF ty_txt,
         codigo(10)   TYPE c,
         nome(30)     TYPE c,
         telefone(14) TYPE c,
       END OF ty_txt.

TYPES: BEGIN OF ty_csv,
         line(100) TYPE c,
       END OF ty_csv.




DATA: t_txt  TYPE TABLE OF ty_txt,
      t_csv  TYPE TABLE OF ty_csv,
      wa_csv TYPE  ty_csv,
      wa_txt TYPE  ty_txt.



PARAMETERS: p_file TYPE localfile,
            p_csv  RADIOBUTTON GROUP gr1,
            p_txt  RADIOBUTTON GROUP gr1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM pega_arquivo.

START-OF-SELECTION.

  PERFORM  f_upload.
  PERFORM f_imprimi_dados.








FORM pega_arquivo .

  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    EXPORTING
*     PROGRAM_NAME  = SYST-REPID
*     DYNPRO_NUMBER = SYST-DYNNR
      field_name    = p_file
*     STATIC        = ' '
*     MASK          = ' '
*     FILEOPERATION = 'R'
*     PATH          =
    CHANGING
      file_name     = p_file
*     LOCATION_FLAG = 'P'
    EXCEPTIONS
      mask_too_long = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    MESSAGE text-001 TYPE 'I'. "" ERRO AO SELECIONAR O ARQUIVO
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_UPLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_upload .
  DATA lv_filename TYPE string.
  FIELD-SYMBOLS <tabela> TYPE STANDARD TABLE.
  lv_filename = p_file.

  IF p_txt = abap_true .
    ASSIGN t_txt TO <tabela>.
  ELSE.
    ASSIGN t_csv TO <tabela>.
  ENDIF.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_filename
      filetype                = 'ASC'
*     HAS_FIELD_SEPARATOR     = ' '
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
* IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      data_tab                = <tabela>
* CHANGING
*     ISSCANPERFORMED         = ' '
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.
  IF sy-subrc <> 0.
MESSAGE text-002 TYPE 'I'."" erro na abertura do arquivo
  STOP.
  ENDIF.
IF p_csv = abap_true.
LOOP AT <tabela> into wa_csv.
  SPLIT wa_csv at ';' into wa_txt-codigo wa_txt-nome wa_txt-telefone.
  APPEND wa_txt to t_txt.
  ENDLOOP.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_IMPRIMI_DADOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_imprimi_dados .
  LOOP AT t_txt INTO wa_txt.
    WRITE:/ wa_txt-codigo, wa_txt-nome, wa_txt-telefone.
  ENDLOOP.
ENDFORM.