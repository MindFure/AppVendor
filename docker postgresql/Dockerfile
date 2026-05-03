FROM postgres:16.13

ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypass
ENV POSTGRES_DB=auto_part_shop

COPY postgresql.conf /etc/postgresql/16/main/postgresql.conf
COPY pg_hba.conf /etc/postgresql/16/main/pg_hba.conf



EXPOSE 5432
