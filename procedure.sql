CREATE OR REPLACE function ОПРЕДЕЛИТЬ_ПОБЕДИТЕЛЯ_ЭНДА(id_энда integer) returns integer AS $$
    DECLARE
        ID_ПОБЕДИТЕЛЯ_ЭНДА integer;
    BEGIN
        SELECT К.ID as ID_КОМАНДЫ FROM МАТЧ
        JOIN ЭНД Э on МАТЧ.ID = Э.ID_МАТЧА
        JOIN БРОСОК Б on Э.ID = Б.ID_ЭНДА  join УЧАСТНИК У on Б.ID_ИГРОКА = У.ID
        join КОМАНДА К on У.ID_КОМАНДА = К.ID WHERE Э.ID = id_энда GROUP BY Э.ID, К.ID ,Э.ID ORDER BY sum(Б.РЕЗУЛЬТАТ) DESC LIMIT 1 INTO ID_ПОБЕДИТЕЛЯ_ЭНДА;
        RETURN ID_ПОБЕДИТЕЛЯ_ЭНДА;
    END;
    $$ LANGUAGE plpgsql;


CREATE OR REPLACE function ОПРЕДЕЛИТЬ_ПОБЕДИТЕЛЯ_МАТЧА(id_матча integer) returns integer AS $$
    DECLARE
        ID_ПОБЕДИТЕЛЯ_МАТЧА integer;
        COUNTER1 integer;
        COUNTER2 integer;
        id_команды1 integer;
        id_команды2 integer;
        id_энда integer;
    BEGIN
        COUNTER1 = 0;
        COUNTER2 = 0;
         select ID_КОМАНДА from МАТЧ М join КОМАНДА_В_МАТЧЕ КВМ on id_матча = КВМ.ID_МАТЧ order by ID_КОМАНДА limit 1 INTO id_команды1;
         select ID_КОМАНДА from МАТЧ М join КОМАНДА_В_МАТЧЕ КВМ on id_матча = КВМ.ID_МАТЧ order by ID_КОМАНДА desc limit 1 INTO id_команды2;
        ID_ПОБЕДИТЕЛЯ_МАТЧА = id_команды1;
        for id_энда in select ЭНД.id from МАТЧ join ЭНД on МАТЧ.id = ЭНД.id_МАТЧА where МАТЧ.id = id_матча loop
            if ОПРЕДЕЛИТЬ_ПОБЕДИТЕЛЯ_ЭНДА(id_энда) = id_команды1 then
                COUNTER1 = COUNTER1 + 1;
            else
                COUNTER2 = COUNTER2 + 1;
            end if;
        end loop;
        IF COUNTER1 > COUNTER2 THEN
            ID_ПОБЕДИТЕЛЯ_МАТЧА = id_команды1;
        ELSE
            ID_ПОБЕДИТЕЛЯ_МАТЧА = id_команды2;
        END IF;
        return ID_ПОБЕДИТЕЛЯ_МАТЧА;
    END;
    $$ LANGUAGE plpgsql;

select *  from ОПРЕДЕЛИТЬ_ПОБЕДИТЕЛЯ_МАТЧА(1);
select ЭНД.id from МАТЧ join ЭНД on МАТЧ.id = ЭНД.id_МАТЧА where МАТЧ.id = 1;

CREATE OR REPLACE FUNCTION ОПРЕДЕЛИТЬ_ПОБЕДИТЕЛЕЙ(id_матча integer) returns TABLE(id integer, id_команды integer,
ИМЯ varchar(256), ВОЗРАСТ integer, ИГРОВОЙ_НОМЕР integer, РОЛЬ "РОЛЬ", РЕГИОН varchar(256)) AS
    $$
    DECLARE
        ID_ПОБЕДИТЕЛЯ_МАТЧА integer;
    BEGIN
        SELECT * FROM ОПРЕДЕЛИТЬ_ПОБЕДИТЕЛЯ_МАТЧА(id_матча) INTO ID_ПОБЕДИТЕЛЯ_МАТЧА;
        return QUERY
            SELECT * FROM УЧАСТНИК WHERE УЧАСТНИК.id_КОМАНДА = ID_ПОБЕДИТЕЛЯ_МАТЧА;
    end;
    $$ LANGUAGE plpgsql;

