CREATE OR REPLACE FUNCTION ДОБАВЛЕНИЕ_КОМАНДЫ_В_МАТЧ() RETURNS trigger AS $$
DECLARE
    КОЛИЧЕСТВО_КОМАНД_В_МАТЧЕ INTEGER;
    КОМАНДА_НА_ДОБАВ RECORD;
BEGIN
    SELECT COUNT(*) FROM КОМАНДА_В_МАТЧЕ WHERE КОМАНДА_В_МАТЧЕ.ID_МАТЧ = NEW.id_МАТЧ INTO КОЛИЧЕСТВО_КОМАНД_В_МАТЧЕ;
    SELECT * FROM КОМАНДА INTO КОМАНДА_НА_ДОБАВ WHERE КОМАНДА.ID = NEW.ID_КОМАНДА;
    IF КОЛИЧЕСТВО_КОМАНД_В_МАТЧЕ >= 2 THEN
        RAISE NOTICE 'Количество команд в матче не может быть больше 2';
        return null;
    END IF;
    IF КОМАНДА_НА_ДОБАВ.ПОДТВЕРЖДЕНА = FALSE THEN
        RAISE NOTICE 'Команда не подтверждена';
        return null;
    END IF;
    IF КОЛИЧЕСТВО_КОМАНД_В_МАТЧЕ < 2 THEN
        RETURN NEW;
    END IF;
    RETURN null;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER ДОБАВЛЕНИЕ_КОМАНДЫ_В_МАТЧ BEFORE INSERT ON КОМАНДА_В_МАТЧЕ FOR EACH ROW EXECUTE PROCEDURE ДОБАВЛЕНИЕ_КОМАНДЫ_В_МАТЧ();

CREATE OR REPLACE FUNCTION БИЛЕТ_НА_МАТЧ() RETURNS trigger AS $$
DECLARE
    КОЛИЧЕСТВО_БИЛЕТОВ_НА_МАТЧ INTEGER;
    КОЛИЧЕСТВО_МЕСТ_В_СТАДИОНЕ INTEGER;
BEGIN
    SELECT COUNT(*) FROM БИЛЕТ Б WHERE Б.id_МАТЧА = NEW.id_МАТЧА INTO КОЛИЧЕСТВО_БИЛЕТОВ_НА_МАТЧ;
    SELECT КОЛИЧЕСТВО_МЕСТ FROM СТАДИОН join
    ТУРНИР on СТАДИОН.ID = ТУРНИР.ID_СТАДИОНА join ГРУППА on ТУРНИР.ID = ГРУППА.ID_ТУРНИРА
        join МАТЧ on ГРУППА.ID = МАТЧ.ID_ГРУППЫ where МАТЧ.ID = NEW.ID_МАТЧА INTO КОЛИЧЕСТВО_МЕСТ_В_СТАДИОНЕ;
    IF КОЛИЧЕСТВО_БИЛЕТОВ_НА_МАТЧ >= КОЛИЧЕСТВО_МЕСТ_В_СТАДИОНЕ THEN
        RAISE NOTICE 'Количество билетов на матч не может быть больше количества мест в стадионе';
        return NULL;
    END IF;
    IF КОЛИЧЕСТВО_БИЛЕТОВ_НА_МАТЧ < КОЛИЧЕСТВО_МЕСТ_В_СТАДИОНЕ THEN
        RETURN NEW;
    END IF;
    return NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER БИЛЕТ_НА_МАТЧ BEFORE INSERT ON БИЛЕТ FOR EACH ROW EXECUTE PROCEDURE БИЛЕТ_НА_МАТЧ();

CREATE OR REPLACE FUNCTION УТВЕРЖДЕНИЕ_РЕГЛАМЕНТА() RETURNS trigger AS $$
    DECLARE
        ДЕЙСТВУЮЩИЙ_РЕГЛАМЕНТ RECORD;
    BEGIN
        SELECT * FROM РЕГЛАМЕНТ WHERE РЕГЛАМЕНТ.ДЕЙСТВУЮЩИЙ = TRUE AND РЕГЛАМЕНТ.ID_ТУРНИРА = NEW.ID_ТУРНИРА
                                INTO  ДЕЙСТВУЮЩИЙ_РЕГЛАМЕНТ;
        if ДЕЙСТВУЮЩИЙ_РЕГЛАМЕНТ is not null then
            if NEW.ДАТА_УТВЕРЖДЕНИЯ >  ДЕЙСТВУЮЩИЙ_РЕГЛАМЕНТ.ДАТА_УТВЕРЖДЕНИЯ then
                UPDATE "РЕГЛАМЕНТ" SET ДЕЙСТВУЮЩИЙ = FALSE WHERE ID = ДЕЙСТВУЮЩИЙ_РЕГЛАМЕНТ.ID;
                RETURN NEW;
            else
                RAISE NOTICE 'Дата утверждения нового регламента не может быть меньше даты утверждения текущего регламента';
                RETURN NULL;
            end if;
        end if;
        RETURN NEW;
    end;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER УТВЕРЖДЕНИЕ_РЕГЛАМЕНТА BEFORE INSERT ON "РЕГЛАМЕНТ" FOR EACH ROW EXECUTE PROCEDURE УТВЕРЖДЕНИЕ_РЕГЛАМЕНТА();


