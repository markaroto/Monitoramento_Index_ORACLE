/* Formatted on 2017/05/30 16:03 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW oraadm.index_comparativo (owner,
                                                       index_name,
                                                       "Ultima_utiliza¿Æo",
                                                       "Tamanho_MB"
                                                      )
AS
   SELECT   t.owner, t.index_name,
            CASE
               WHEN MAX (a.TIMESTAMP) IS NULL
                  THEN 'NaoUtilizado'
               ELSE TO_CHAR
                      (MAX (a.TIMESTAMP),
                       'DD-MM-YYYY HH24:MI'
                      )                              --AS "Ultima_utiliza¿Æo",
            END AS "UltimaUtilizacao",
            (t.BYTES / 1024 / 1024) "Tamanho_MB"
       FROM oraadm.index_total t LEFT JOIN oraadm.index_audit a
            ON a.name_index = t.index_name AND t.owner = a.owner
   --where A.TIMESTAMP is not null
   GROUP BY t.owner, t.index_name, t.BYTES;


/* Formatted on 2017/05/30 16:03 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW oraadm.index_total (owner,
                                                 index_name,
                                                 index_type,
                                                 table_owner,
                                                 table_name,
                                                 BYTES
                                                )
AS
   SELECT i.owner, i.index_name, i.index_type, i.table_owner, i.table_name,
          s.BYTES
     FROM dba_indexes i JOIN dba_segments s
          ON i.owner = s.owner AND s.segment_name = i.index_name
    WHERE i.owner NOT IN ('SYSAUX', 'SYSTEM', 'NEXADB', 'ORAADM', 'SYS')
      AND i.index_type = UPPER ('normal')
      AND i.tablespace_name NOT IN ('SYSTEM', 'SYSAUX');


	  
/* Formatted on 2017/05/30 16:03 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW oraadm.index_ultimo_30_dias (owner,
                                                          index_name,
                                                          "UltimaUtilizacao",
                                                          "QuantidadeUtilizacao",
                                                          "Tamanho_MB"
                                                         )
AS
   SELECT   t.owner, t.index_name,
            CASE
               WHEN MAX (a.TIMESTAMP) IS NULL
                  THEN 'NaoUtilizado'
               ELSE TO_CHAR
                      (MAX (a.TIMESTAMP),
                       'DD-MM-YYYY HH24:MI'
                      )                              --AS "Ultima_utiliza¿Æo",
            END AS "UltimaUtilizacao",
            COUNT (a.name_index) AS "QuantidadeUtilizacao",
            (t.BYTES / 1024 / 1024) "Tamanho_MB"
       FROM oraadm.index_total t LEFT JOIN oraadm.index_audit a
            ON a.name_index = t.index_name
          AND t.owner = a.owner
          AND TO_DATE (a.TIMESTAMP, 'dd/mm/yy') >=
                                         TO_DATE ((SYSDATE - 30), 'dd/mm/yy')
   --where A.TIMESTAMP is not null
   GROUP BY t.owner, t.index_name, t.BYTES;

	  
	  
