CREATE OR REPLACE procedure ORAADM.atualizar_index
as
begin
    insert into ORAADM.INDEX_AUDIT (owner,name_index,object_alias,object_type,timestamp)
        (select object_owner,object_name, object_alias, object_type , timestamp
            from SYS.V_$SQL_PLAN where operation='INDEX' and object_owner in
                (select USERNAME from SYS.dba_users where default_tablespace not in ('SYSAUX','SYSTEM','NEXADB','ORAADM'))
                 and timestamp > TO_DATE( ( 
                    select 
                        case
                            when  MAX (TIMESTAMP) is null
                            then '02-02-2014 00:00:00'
                        else 
                            to_char(MAX(TIMESTAMP),'DD-MM-YYYY HH24:MI:SS')
                        end as end_date 
                    from ORAADM.INDEX_AUDIT),'DD-MM-YYYY HH24:MI:SS')
                 
                 
                 );
     commit;
end;
/