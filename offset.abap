REPORT zism_offset.
**********************************************************************
* esse é um report que tem como finalidade
*trazer um exemplo do conceito de offset em abap
**********************************************************************
DATA: i_day(2)       TYPE c,
      i_month(2)    TYPE c,
      i_year(4)      TYPE c,
      i_datacompleta(8) TYPE c.

WRITE:'essa é a data completa:' ,'-> ', sy-datum. " pegamos a data atual.

ULINE.

i_year = sy-datum(4). "" dessa forma estamos pegando os 4 primeiros caracteres e atribuindo a variável i_year.

WRITE: 'agora apenas o ando:','-> ',i_year. "" aqui exibimos apenas o ano

ULINE.
i_month = sy-datum+4(2). "" +4 quer dizer que pulamos quatro caracteres, pegamos os 2 seguintes e atribuimos a variável i_month .

WRITE: 'apenas o mês','-> ',i_month. "" aqui exibimos apenas o mês

ULINE.
i_day = sy-datum+6(2). "agora pulamos os 6 primeiros e pegamos os 2 ultimos caracteres e atribuimos a variável i_day.

WRITE: 'por fim a data do dia','-> ', i_day. " aqui exibimos apenas o dia

ULINE.

CONCATENATE i_day i_month i_year INTO i_datacompleta. " aqui concatenamos todas as variáveis sem separadores e atribuimos a variável i_datacompleta

WRITE: 'essa é a data concatenada sem separadores', i_datacompleta. " aqui exibimos o resultado

ULINE.

CONCATENATE i_day '/' i_month '/' i_year INTO i_datacompleta. "aqui ja concatenamos com a barra para separar.

WRITE: 'essa é a data concatenada com separadores', i_datacompleta.