DO $$ DECLARE
r RECORD;
BEGIN
FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname =
's309552') LOOP
EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || '
CASCADE';
END LOOP;
END $$;

TRUNCATE ОРГАНИЗАЦИЯ CASCADE;
TRUNCATE БИЛЕТ CASCADE;
TRUNCATE БРОСОК CASCADE;
TRUNCATE "ГРУППА" CASCADE;
TRUNCATE "КОМАНДА" CASCADE;
TRUNCATE "КОМАНДА_В_МАТЧЕ" CASCADE;
TRUNCATE "МАТЧ" CASCADE;
TRUNCATE "ПРАВИЛО" CASCADE;
TRUNCATE "ПРАВИЛО_В_РЕГЛАМЕНТЕ" CASCADE;
TRUNCATE "ПРОТОКОЛ_МАТЧА" CASCADE;
TRUNCATE "РЕГЛАМЕНТ" CASCADE;
TRUNCATE "СОБЫТИЕ" CASCADE;
TRUNCATE "СТАДИОН" CASCADE;
TRUNCATE "СОТРУДНИК" CASCADE;
TRUNCATE "СОТРУДНИК_МАТЧА" CASCADE;
TRUNCATE "ТУРНИР" CASCADE;
TRUNCATE "УЧАСТНИК" CASCADE;
TRUNCATE "ЭНД" CASCADE;
