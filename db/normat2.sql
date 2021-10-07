create sequence t_ili2db_seq;

alter sequence t_ili2db_seq owner to rdppfdb_dbo;

grant select, update, usage on sequence t_ili2db_seq to rdppfdb_edit;

create table if not exists t_ili2db_dataset
(
    t_id        bigint not null
        constraint t_ili2db_dataset_pkey
            primary key,
    datasetname varchar(200)
);

alter table t_ili2db_dataset
    owner to rdppfdb_dbo;

create table if not exists t_ili2db_basket
(
    t_id          bigint       not null
        constraint t_ili2db_basket_pkey
            primary key,
    dataset       bigint
        constraint t_ili2db_basket_dataset_fkey
            references t_ili2db_dataset
            deferrable initially deferred,
    topic         varchar(200) not null,
    t_ili_tid     varchar(200),
    attachmentkey varchar(200) not null,
    domains       varchar(1024)
);

alter table t_ili2db_basket
    owner to rdppfdb_dbo;

create table if not exists echelonnementdelequipement
(
    t_id               bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint echelonnementdelequipement_pkey
            primary key,
    t_basket           bigint
        constraint echelonnementdelequipement_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid          varchar(200),
    geometrie          geometry(Polygon, 2056),
    arretdelequipement boolean,
    remarques          text
);

alter table echelonnementdelequipement
    owner to rdppfdb_dbo;

grant insert, select, update, delete on echelonnementdelequipement to rdppfdb_edit;

create index if not exists echelonnementdelequipement_t_basket_idx
    on echelonnementdelequipement (t_basket);

create index if not exists echelonnementdelequipement_geometrie_idx
    on echelonnementdelequipement (geometrie);

create table if not exists office
(
    t_id      bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint office_pkey
            primary key,
    t_basket  bigint
        constraint office_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid varchar(200),
    nom       varchar(80),
    auid      varchar(12)
);

alter table office
    owner to rdppfdb_dbo;

grant insert, select, update, delete on office to rdppfdb_edit;

create index if not exists office_t_basket_idx
    on office (t_basket);

create table if not exists jeudedonnees
(
    t_id                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint jeudedonnees_pkey
            primary key,
    t_basket             bigint
        constraint jeudedonnees_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid            varchar(200),
    basketid             varchar(20),
    version              date,
    datedelivraison      date,
    remarques            text,
    organismeresponsable bigint
        constraint jeudedonnees_organismeresponsable_fkey
            references office
            deferrable initially deferred
);

alter table jeudedonnees
    owner to rdppfdb_dbo;

grant insert, select, update, delete on jeudedonnees to rdppfdb_edit;

create index if not exists jeudedonnees_t_basket_idx
    on jeudedonnees (t_basket);

create index if not exists jeudedonnees_organismeresponsable_idx
    on jeudedonnees (organismeresponsable);

create table if not exists distncs95_v1_1metadonnestrnsfer_jeudedonnees
(
    t_id                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint distncs95_v1_1metadonnestrnsfer_jeudedonnees_pkey
            primary key,
    t_basket             bigint
        constraint distncs95_v1_nsfr_jddnnees_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid            varchar(200),
    basketid             varchar(20),
    version              date,
    datedelivraison      date,
    remarques            text,
    organismeresponsable bigint
        constraint distncs95_v1_1metadonnestrnsfer_jeudedonnees_organismeresponsab
            references office
            deferrable initially deferred
);

alter table distncs95_v1_1metadonnestrnsfer_jeudedonnees
    owner to rdppfdb_dbo;

grant insert, select, update, delete on distncs95_v1_1metadonnestrnsfer_jeudedonnees to rdppfdb_edit;

create index if not exists distncs95_v1_nsfr_jddnnees_t_basket_idx
    on distncs95_v1_1metadonnestrnsfer_jeudedonnees (t_basket);

create index if not exists distncs95_v1_nsfr_jddnnees_organismeresponsable_idx
    on distncs95_v1_1metadonnestrnsfer_jeudedonnees (organismeresponsable);

create table if not exists affectationprincipale_ch
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint affectationprincipale_ch_pkey
            primary key,
    t_basket    bigint
        constraint affectationprincipale_ch_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid   varchar(200),
    acode       integer
        constraint affectationprincipale_ch_acode_check
            check ((acode >= 11) AND (acode <= 99)),
    designation varchar(80)
);

alter table affectationprincipale_ch
    owner to rdppfdb_dbo;

grant insert, select, update, delete on affectationprincipale_ch to rdppfdb_edit;

create index if not exists affectationprincipale_ch_t_basket_idx
    on affectationprincipale_ch (t_basket);

create table if not exists type_ct
(
    t_id                     bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint type_ct_pkey
            primary key,
    t_basket                 bigint
        constraint type_ct_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid                varchar(200),
    acode                    varchar(12),
    designation              varchar(80),
    abreviation              varchar(12),
    remarques                text,
    affectationprincipale_ch bigint
        constraint type_ct_affectationprincipale_ch_fkey
            references affectationprincipale_ch
            deferrable initially deferred
);

alter table type_ct
    owner to rdppfdb_dbo;

grant insert, select, update, delete on type_ct to rdppfdb_edit;

create index if not exists type_ct_t_basket_idx
    on type_ct (t_basket);

create index if not exists type_ct_affectationprincipale_ch_idx
    on type_ct (affectationprincipale_ch);

create table if not exists plansdf95_v1_1metadonnestrnsfer_jeudedonnees
(
    t_id                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint plansdf95_v1_1metadonnestrnsfer_jeudedonnees_pkey
            primary key,
    t_basket             bigint
        constraint plansdf95_v1_nsfr_jddnnees_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid            varchar(200),
    basketid             varchar(20),
    version              date,
    datedelivraison      date,
    remarques            text,
    organismeresponsable bigint
        constraint plansdf95_v1_1metadonnestrnsfer_jeudedonnees_organismeresponsab
            references office
            deferrable initially deferred
);

alter table plansdf95_v1_1metadonnestrnsfer_jeudedonnees
    owner to rdppfdb_dbo;

grant insert, select, update, delete on plansdf95_v1_1metadonnestrnsfer_jeudedonnees to rdppfdb_edit;

create index if not exists plansdf95_v1_nsfr_jddnnees_t_basket_idx
    on plansdf95_v1_1metadonnestrnsfer_jeudedonnees (t_basket);

create index if not exists plansdf95_v1_nsfr_jddnnees_organismeresponsable_idx
    on plansdf95_v1_1metadonnestrnsfer_jeudedonnees (organismeresponsable);

create table if not exists degrdsn95_v1_1metadonnestrnsfer_jeudedonnees
(
    t_id                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint degrdsn95_v1_1metadonnestrnsfer_jeudedonnees_pkey
            primary key,
    t_basket             bigint
        constraint degrdsn95_v1_nsfr_jddnnees_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid            varchar(200),
    basketid             varchar(20),
    version              date,
    datedelivraison      date,
    remarques            text,
    organismeresponsable bigint
        constraint degrdsn95_v1_1metadonnestrnsfer_jeudedonnees_organismeresponsab
            references office
            deferrable initially deferred
);

alter table degrdsn95_v1_1metadonnestrnsfer_jeudedonnees
    owner to rdppfdb_dbo;

grant insert, select, update, delete on degrdsn95_v1_1metadonnestrnsfer_jeudedonnees to rdppfdb_edit;

create index if not exists degrdsn95_v1_nsfr_jddnnees_t_basket_idx
    on degrdsn95_v1_1metadonnestrnsfer_jeudedonnees (t_basket);

create index if not exists degrdsn95_v1_nsfr_jddnnees_organismeresponsable_idx
    on degrdsn95_v1_1metadonnestrnsfer_jeudedonnees (organismeresponsable);

create table if not exists limtsdl95_v1_1metadonnestrnsfer_jeudedonnees
(
    t_id                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint limtsdl95_v1_1metadonnestrnsfer_jeudedonnees_pkey
            primary key,
    t_basket             bigint
        constraint limtsdl95_v1_nsfr_jddnnees_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid            varchar(200),
    basketid             varchar(20),
    version              date,
    datedelivraison      date,
    remarques            text,
    organismeresponsable bigint
        constraint limtsdl95_v1_1metadonnestrnsfer_jeudedonnees_organismeresponsab
            references office
            deferrable initially deferred
);

alter table limtsdl95_v1_1metadonnestrnsfer_jeudedonnees
    owner to rdppfdb_dbo;

grant insert, select, update, delete on limtsdl95_v1_1metadonnestrnsfer_jeudedonnees to rdppfdb_edit;

create index if not exists limtsdl95_v1_nsfr_jddnnees_t_basket_idx
    on limtsdl95_v1_1metadonnestrnsfer_jeudedonnees (t_basket);

create index if not exists limtsdl95_v1_nsfr_jddnnees_organismeresponsable_idx
    on limtsdl95_v1_1metadonnestrnsfer_jeudedonnees (organismeresponsable);

create table if not exists zons_rsmn95_v1metadonnestrnsfer_jeudedonnees
(
    t_id                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint zons_rsmn95_v1metadonnestrnsfer_jeudedonnees_pkey
            primary key,
    t_basket             bigint
        constraint zons_rsmn95_vnsfr_jddnnees_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid            varchar(200),
    basketid             varchar(20),
    version              date,
    datedelivraison      date,
    remarques            text,
    organismeresponsable bigint
        constraint zons_rsmn95_v1metadonnestrnsfer_jeudedonnees_organismeresponsab
            references office
            deferrable initially deferred
);

alter table zons_rsmn95_v1metadonnestrnsfer_jeudedonnees
    owner to rdppfdb_dbo;

grant insert, select, update, delete on zons_rsmn95_v1metadonnestrnsfer_jeudedonnees to rdppfdb_edit;

create index if not exists zons_rsmn95_vnsfr_jddnnees_t_basket_idx
    on zons_rsmn95_v1metadonnestrnsfer_jeudedonnees (t_basket);

create index if not exists zons_rsmn95_vnsfr_jddnnees_organismeresponsable_idx
    on zons_rsmn95_v1metadonnestrnsfer_jeudedonnees (organismeresponsable);

grant insert, select, update, delete on t_ili2db_basket to rdppfdb_edit;

create index if not exists t_ili2db_basket_dataset_idx
    on t_ili2db_basket (dataset);

grant insert, select, update, delete on t_ili2db_dataset to rdppfdb_edit;

create unique index if not exists t_ili2db_dataset_datasetname_key
    on t_ili2db_dataset (datasetname);

create table if not exists t_ili2db_inheritance
(
    thisclass varchar(1024) not null
        constraint t_ili2db_inheritance_pkey
            primary key,
    baseclass varchar(1024)
);

alter table t_ili2db_inheritance
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_inheritance to rdppfdb_edit;

create table if not exists t_ili2db_settings
(
    tag     varchar(60) not null
        constraint t_ili2db_settings_pkey
            primary key,
    setting varchar(8000)
);

alter table t_ili2db_settings
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_settings to rdppfdb_edit;

create table if not exists t_ili2db_trafo
(
    iliname varchar(1024) not null,
    tag     varchar(1024) not null,
    setting varchar(1024) not null
);

alter table t_ili2db_trafo
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_trafo to rdppfdb_edit;

create table if not exists t_ili2db_model
(
    filename   varchar(250) not null,
    iliversion varchar(3)   not null,
    modelname  text         not null,
    content    text         not null,
    importdate timestamp    not null,
    constraint t_ili2db_model_pkey
        primary key (modelname, iliversion)
);

alter table t_ili2db_model
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_model to rdppfdb_edit;

create unique index if not exists t_ili2db_model_modelname_iliversion_key
    on t_ili2db_model (modelname, iliversion);

create table if not exists genre_limiteforestiere
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint genre_limiteforestiere_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table genre_limiteforestiere
    owner to rdppfdb_dbo;

grant insert, select, update, delete on genre_limiteforestiere to rdppfdb_edit;

create table if not exists dispositionniveau
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint dispositionniveau_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table dispositionniveau
    owner to rdppfdb_dbo;

create table if not exists type_zonereservee
(
    t_id              bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint type_zonereservee_pkey
            primary key,
    t_basket          bigint
        constraint type_zonereservee_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid         varchar(200),
    acode             varchar(12),
    designation       varchar(80),
    abreviation       varchar(12),
    dispositionniveau bigint
        constraint type_zonereservee_dispositionniveau_fkey
            references dispositionniveau
            deferrable initially deferred,
    remarques         text,
    symbole           bytea
);

alter table type_zonereservee
    owner to rdppfdb_dbo;

grant insert, select, update, delete on type_zonereservee to rdppfdb_edit;

create index if not exists type_zonereservee_t_basket_idx
    on type_zonereservee (t_basket);

create index if not exists type_zonereservee_dispositionniveau_idx
    on type_zonereservee (dispositionniveau);

grant insert, select, update, delete on dispositionniveau to rdppfdb_edit;

create table if not exists etat_construction
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint etat_construction_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table etat_construction
    owner to rdppfdb_dbo;

grant insert, select, update, delete on etat_construction to rdppfdb_edit;

create table if not exists statutjuridique
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint statutjuridique_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table statutjuridique
    owner to rdppfdb_dbo;

create table if not exists zonereservee
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint zonereservee_pkey
            primary key,
    t_basket        bigint
        constraint zonereservee_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(Polygon, 2056),
    publieedepuis   date,
    valablejusqua   date,
    statutjuridique bigint
        constraint zonereservee_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    remarques       text,
    typzr           bigint
        constraint zonereservee_typzr_fkey
            references type_zonereservee
            deferrable initially deferred
);

alter table zonereservee
    owner to rdppfdb_dbo;

grant insert, select, update, delete on zonereservee to rdppfdb_edit;

create index if not exists zonereservee_t_basket_idx
    on zonereservee (t_basket);

create index if not exists zonereservee_geometrie_idx
    on zonereservee (geometrie);

create index if not exists zonereservee_statutjurdique_idx
    on zonereservee (statutjuridique);

create index if not exists zonereservee_typzr_idx
    on zonereservee (typzr);

grant insert, select, update, delete on statutjuridique to rdppfdb_edit;

create table if not exists forceobligatoire
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint forceobligatoire_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table forceobligatoire
    owner to rdppfdb_dbo;

create table if not exists atype
(
    t_id             bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint atype_pkey
            primary key,
    t_basket         bigint
        constraint atype_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid        varchar(200),
    acode            varchar(12),
    designation      varchar(80),
    abreviation      varchar(10),
    forceobligatoire bigint
        constraint atype_forceobligatoire_fkey
            references forceobligatoire
            deferrable initially deferred,
    remarques        text,
    symbole          bytea
);

alter table atype
    owner to rdppfdb_dbo;

grant insert, select, update, delete on atype to rdppfdb_edit;

create index if not exists atype_t_basket_idx
    on atype (t_basket);

create index if not exists atype_forceobligatoire_idx
    on atype (forceobligatoire);

create table if not exists distanceparrapportalaforet_ligne
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint distanceparrapportalaforet_ligne_pkey
            primary key,
    t_basket        bigint
        constraint distanceparrapprtlfrt_lgne_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(LineString, 2056),
    statutjuridique bigint
        constraint distanceparrapportalaforet_ligne_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    publieedepuis   date,
    remarques       text,
    df              bigint
        constraint distanceparrapprtlfrt_lgne_df_fkey
            references atype
            deferrable initially deferred
);

alter table distanceparrapportalaforet_ligne
    owner to rdppfdb_dbo;

grant insert, select, update, delete on distanceparrapportalaforet_ligne to rdppfdb_edit;

create index if not exists distanceparrapprtlfrt_lgne_t_basket_idx
    on distanceparrapportalaforet_ligne (t_basket);

create index if not exists distanceparrapprtlfrt_lgne_geometrie_idx
    on distanceparrapportalaforet_ligne (geometrie);

create index if not exists distanceparrapprtlfrt_lgne_statutjuridique_idx
    on distanceparrapportalaforet_ligne (statutjuridique);

create index if not exists distanceparrapprtlfrt_lgne_df_idx
    on distanceparrapportalaforet_ligne (df);

create table if not exists plansdf95_v1_1geodonneesdebase_type
(
    t_id                  bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint plansdf95_v1_1geodonneesdebase_type_pkey
            primary key,
    t_basket              bigint
        constraint plansdf95_v1_gdnnsdbs_type_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid             varchar(200),
    acode                 varchar(12),
    designation           varchar(80),
    abreviation           varchar(12),
    forceobligatoire      bigint
        constraint plansdf95_v1_1geodonneesdebase_type_forceobligatoire_fkey
            references forceobligatoire
            deferrable initially deferred,
    indiceutilisation     numeric(3, 2)
        constraint plansdf95_v1gdnnsdbs_type_indiceutilisation_check
            check ((indiceutilisation >= 0.0) AND (indiceutilisation <= 9.0)),
    indiceutilisationtype varchar(40),
    remarques             text,
    symbole               bytea,
    type_ct               bigint
        constraint plansdf95_v1_gdnnsdbs_type_type_ct_fkey
            references type_ct
            deferrable initially deferred
);

alter table plansdf95_v1_1geodonneesdebase_type
    owner to rdppfdb_dbo;

grant insert, select, update, delete on plansdf95_v1_1geodonneesdebase_type to rdppfdb_edit;

create index if not exists plansdf95_v1_gdnnsdbs_type_t_basket_idx
    on plansdf95_v1_1geodonneesdebase_type (t_basket);

create index if not exists plansdf95_v1_gdnnsdbs_type_forceobligatoire_idx
    on plansdf95_v1_1geodonneesdebase_type (forceobligatoire);

create index if not exists plansdf95_v1_gdnnsdbs_type_type_ct_idx
    on plansdf95_v1_1geodonneesdebase_type (type_ct);

create table if not exists affectationprimaire_surfacedezones
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint affectationprimaire_surfacedezones_pkey
            primary key,
    t_basket        bigint
        constraint affectationprimr_srfcdznes_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(Polygon, 2056),
    publieedepuis   date,
    statutjuridique bigint
        constraint affectationprimaire_surfacedezones_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    remarques       text,
    atype           bigint
        constraint affectationprimr_srfcdznes_atype_fkey
            references plansdf95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table affectationprimaire_surfacedezones
    owner to rdppfdb_dbo;

grant insert, select, update, delete on affectationprimaire_surfacedezones to rdppfdb_edit;

create index if not exists affectationprimr_srfcdznes_t_basket_idx
    on affectationprimaire_surfacedezones (t_basket);

create index if not exists affectationprimr_srfcdznes_geometrie_idx
    on affectationprimaire_surfacedezones (geometrie);

create index if not exists affectationprimr_srfcdznes_statutjuridique_idx
    on affectationprimaire_surfacedezones (statutjuridique);

create index if not exists affectationprimr_srfcdznes_atype_idx
    on affectationprimaire_surfacedezones (atype);

create table if not exists contenulineaire
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint contenulineaire_pkey
            primary key,
    t_basket        bigint
        constraint contenulineaire_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(LineString, 2056),
    publieedepuis   date,
    statutjuridique bigint
        constraint contenulineaire_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    remarques       text,
    atype           bigint
        constraint contenulineaire_atype_fkey
            references plansdf95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table contenulineaire
    owner to rdppfdb_dbo;

grant insert, select, update, delete on contenulineaire to rdppfdb_edit;

create index if not exists contenulineaire_t_basket_idx
    on contenulineaire (t_basket);

create index if not exists contenulineaire_geometrie_idx
    on contenulineaire (geometrie);

create index if not exists contenulineaire_statutjuridique_idx
    on contenulineaire (statutjuridique);

create index if not exists contenulineaire_atype_idx
    on contenulineaire (atype);

create table if not exists contenuponctuel
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint contenuponctuel_pkey
            primary key,
    t_basket        bigint
        constraint contenuponctuel_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(Point, 2056),
    publieedepuis   date,
    statutjuridique bigint
        constraint contenuponctuel_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    remarques       text,
    atype           bigint
        constraint contenuponctuel_atype_fkey
            references plansdf95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table contenuponctuel
    owner to rdppfdb_dbo;

grant insert, select, update, delete on contenuponctuel to rdppfdb_edit;

create index if not exists contenuponctuel_t_basket_idx
    on contenuponctuel (t_basket);

create index if not exists contenuponctuel_geometrie_idx
    on contenuponctuel (geometrie);

create index if not exists contenuponctuel_statutjuridique_idx
    on contenuponctuel (statutjuridique);

create index if not exists contenuponctuel_atype_idx
    on contenuponctuel (atype);

create table if not exists zonesuperposee
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint zonesuperposee_pkey
            primary key,
    t_basket        bigint
        constraint zonesuperposee_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(Polygon, 2056),
    publieedepuis   date,
    statutjuridique bigint
        constraint zonesuperposee_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    remarques       text,
    atype           bigint
        constraint zonesuperposee_atype_fkey
            references plansdf95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table zonesuperposee
    owner to rdppfdb_dbo;

grant insert, select, update, delete on zonesuperposee to rdppfdb_edit;

create index if not exists zonesuperposee_t_basket_idx
    on zonesuperposee (t_basket);

create index if not exists zonesuperposee_geometrie_idx
    on zonesuperposee (geometrie);

create index if not exists zonesuperposee_statutjuridique_idx
    on zonesuperposee (statutjuridique);

create index if not exists zonesuperposee_atype_idx
    on zonesuperposee (atype);

create table if not exists limtsdl95_v1_1geodonneesdebase_type
(
    t_id             bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint limtsdl95_v1_1geodonneesdebase_type_pkey
            primary key,
    t_basket         bigint
        constraint limtsdl95_v1_gdnnsdbs_type_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid        varchar(200),
    acode            varchar(12),
    designation      varchar(80),
    abreviation      varchar(10),
    forceobligatoire bigint
        constraint limtsdl95_v1_1geodonneesdebase_type_forceobligatoire_fkey
            references forceobligatoire
            deferrable initially deferred,
    remarques        text,
    genre            bigint
        constraint limtsdl95_v1_gdnnsdbs_type_genre_fkey
            references genre_limiteforestiere
            deferrable initially deferred,
    symbole          bytea
);

alter table limtsdl95_v1_1geodonneesdebase_type
    owner to rdppfdb_dbo;

grant insert, select, update, delete on limtsdl95_v1_1geodonneesdebase_type to rdppfdb_edit;

create index if not exists limtsdl95_v1_gdnnsdbs_type_t_basket_idx
    on limtsdl95_v1_1geodonneesdebase_type (t_basket);

create index if not exists limtsdl95_v1_gdnnsdbs_type_forceobligatoire_idx
    on limtsdl95_v1_1geodonneesdebase_type (forceobligatoire);

create index if not exists limtsdl95_v1_gdnnsdbs_type_genre_idx
    on limtsdl95_v1_1geodonneesdebase_type (genre);

create table if not exists limitedelaforet_ligne
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint limitedelaforet_ligne_pkey
            primary key,
    t_basket        bigint
        constraint limitedelaforet_ligne_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(LineString, 2056),
    statutjuridique bigint
        constraint limitedelaforet_ligne_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    publieedepuis   date,
    remarques       text,
    lf              bigint
        constraint limitedelaforet_ligne_lf_fkey
            references limtsdl95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table limitedelaforet_ligne
    owner to rdppfdb_dbo;

grant insert, select, update, delete on limitedelaforet_ligne to rdppfdb_edit;

create index if not exists limitedelaforet_ligne_t_basket_idx
    on limitedelaforet_ligne (t_basket);

create index if not exists limitedelaforet_ligne_geometrie_idx
    on limitedelaforet_ligne (geometrie);

create index if not exists limitedelaforet_ligne_statutjuridique_idx
    on limitedelaforet_ligne (statutjuridique);

create index if not exists limitedelaforet_ligne_lf_idx
    on limitedelaforet_ligne (lf);

grant insert, select, update, delete on forceobligatoire to rdppfdb_edit;

create table if not exists languagecode_iso639_1
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint languagecode_iso639_1_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table languagecode_iso639_1
    owner to rdppfdb_dbo;

grant insert, select, update, delete on languagecode_iso639_1 to rdppfdb_edit;

create table if not exists ds
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint ds_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table ds
    owner to rdppfdb_dbo;

create table if not exists degrdsn95_v1_1geodonneesdebase_type
(
    t_id             bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint degrdsn95_v1_1geodonneesdebase_type_pkey
            primary key,
    t_basket         bigint
        constraint degrdsn95_v1_gdnnsdbs_type_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid        varchar(200),
    acode            varchar(12),
    designation      varchar(80),
    abreviation      varchar(10),
    degre            bigint
        constraint degrdsn95_v1_gdnnsdbs_type_degre_fkey
            references ds
            deferrable initially deferred,
    declassement     boolean,
    forceobligatoire bigint
        constraint degrdsn95_v1_1geodonneesdebase_type_forceobligatoire_fkey
            references forceobligatoire
            deferrable initially deferred,
    remarques        text,
    symbole          bytea
);

alter table degrdsn95_v1_1geodonneesdebase_type
    owner to rdppfdb_dbo;

create table if not exists zone_sensibiliteaubruit
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint zone_sensibiliteaubruit_pkey
            primary key,
    t_basket        bigint
        constraint zone_sensibiliteaubruit_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    geometrie       geometry(Polygon, 2056),
    statutjuridique bigint
        constraint zone_sensibiliteaubruit_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    publieedepuis   date,
    remarques       text,
    ds              bigint
        constraint zone_sensibiliteaubruit_ds_fkey
            references degrdsn95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table zone_sensibiliteaubruit
    owner to rdppfdb_dbo;

grant insert, select, update, delete on zone_sensibiliteaubruit to rdppfdb_edit;

create index if not exists zone_sensibiliteaubruit_t_basket_idx
    on zone_sensibiliteaubruit (t_basket);

create index if not exists zone_sensibiliteaubruit_geometrie_idx
    on zone_sensibiliteaubruit (geometrie);

create index if not exists zone_sensibiliteaubruit_statutjuridique_idx
    on zone_sensibiliteaubruit (statutjuridique);

create index if not exists zone_sensibiliteaubruit_ds_idx
    on zone_sensibiliteaubruit (ds);

grant insert, select, update, delete on degrdsn95_v1_1geodonneesdebase_type to rdppfdb_edit;

create index if not exists degrdsn95_v1_gdnnsdbs_type_t_basket_idx
    on degrdsn95_v1_1geodonneesdebase_type (t_basket);

create index if not exists degrdsn95_v1_gdnnsdbs_type_degre_idx
    on degrdsn95_v1_1geodonneesdebase_type (degre);

create index if not exists degrdsn95_v1_gdnnsdbs_type_forceobligatoire_idx
    on degrdsn95_v1_1geodonneesdebase_type (forceobligatoire);

grant insert, select, update, delete on ds to rdppfdb_edit;

create table if not exists aptitude_construction
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint aptitude_construction_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table aptitude_construction
    owner to rdppfdb_dbo;

grant insert, select, update, delete on aptitude_construction to rdppfdb_edit;

create table if not exists chcantoncode
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint chcantoncode_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table chcantoncode
    owner to rdppfdb_dbo;

create table if not exists document
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint document_pkey
            primary key,
    t_basket        bigint
        constraint document_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    titre           varchar(80),
    titreofficiel   text,
    abreviation     varchar(12),
    noofficiel      varchar(20),
    canton          bigint
        constraint document_canton_fkey
            references chcantoncode
            deferrable initially deferred,
    commune         integer
        constraint document_commune_check
            check ((commune >= 1) AND (commune <= 9999)),
    publiedepuis    date,
    statutjuridique bigint
        constraint document_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    remarques       text
);

alter table document
    owner to rdppfdb_dbo;

grant insert, select, update, delete on document to rdppfdb_edit;

create index if not exists document_t_basket_idx
    on document (t_basket);

create index if not exists document_canton_idx
    on document (canton);

create index if not exists document_statutjuridique_idx
    on document (statutjuridique);

create table if not exists dispositionjuridique
(
    t_id            bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint dispositionjuridique_pkey
            primary key,
    t_basket        bigint
        constraint dispositionjuridique_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid       varchar(200),
    titre           varchar(80),
    titreofficiel   text,
    abreviation     varchar(12),
    noofficiel      varchar(20),
    canton          bigint
        constraint dispositionjuridique_canton_fkey
            references chcantoncode
            deferrable initially deferred,
    commune         integer
        constraint dispositionjuridique_commune_check
            check ((commune >= 1) AND (commune <= 9999)),
    publiedepuis    date,
    statutjuridique bigint
        constraint dispositionjuridique_statutjuridique_fkey
            references statutjuridique
            deferrable initially deferred,
    remarques       text
);

alter table dispositionjuridique
    owner to rdppfdb_dbo;

create table if not exists multilingualuri
(
    t_id                  bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint multilingualuri_pkey
            primary key,
    t_basket              bigint
        constraint multilingualuri_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid             varchar(200),
    t_seq                 bigint,
    office_guichetenligne bigint
        constraint multilingualuri_office_guichetenligne_fkey
            references office
            deferrable initially deferred,
    disposition_juridique bigint
        constraint multilingualuri_disposition_juridique_fkey
            references dispositionjuridique,
    document              bigint
        constraint multilingualuri_document_fkey
            references document
);

alter table multilingualuri
    owner to rdppfdb_dbo;

create table if not exists localiseduri
(
    t_id                          bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint localiseduri_pkey
            primary key,
    t_basket                      bigint
        constraint localiseduri_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid                     varchar(200),
    t_seq                         bigint,
    alanguage                     bigint
        constraint localiseduri_alanguage_fkey
            references languagecode_iso639_1
            deferrable initially deferred,
    atext                         varchar(1023),
    multilingualuri_localisedtext bigint
        constraint localiseduri_multilingualuri_loclsdtext_fkey
            references multilingualuri
            deferrable initially deferred
);

alter table localiseduri
    owner to rdppfdb_dbo;

grant insert, select, update, delete on localiseduri to rdppfdb_edit;

create index if not exists localiseduri_t_basket_idx
    on localiseduri (t_basket);

create index if not exists localiseduri_alanguage_idx
    on localiseduri (alanguage);

create index if not exists localiseduri_multilingualuri_loclsdtext_idx
    on localiseduri (multilingualuri_localisedtext);

grant insert, select, update, delete on multilingualuri to rdppfdb_edit;

create index if not exists multilingualuri_t_basket_idx
    on multilingualuri (t_basket);

create index if not exists multilingualuri_office_guichetenligne_idx
    on multilingualuri (office_guichetenligne);

grant insert, select, update, delete on dispositionjuridique to rdppfdb_edit;

create index if not exists dispositionjuridique_t_basket_idx
    on dispositionjuridique (t_basket);

create index if not exists dispositionjuridique_canton_idx
    on dispositionjuridique (canton);

create index if not exists dispositionjuridique_statutjuridique_idx
    on dispositionjuridique (statutjuridique);

create table if not exists autresdocuments
(
    t_id                          bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint autresdocuments_pkey
            primary key,
    t_basket                      bigint
        constraint autresdocuments_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    origine_document              bigint
        constraint autresdocuments_origine_document_fkey
            references document
            deferrable initially deferred,
    origine_dispositionjuridique  bigint
        constraint autresdocuments_origine_dispositionjurdque_fkey
            references dispositionjuridique
            deferrable initially deferred,
    document_document             bigint
        constraint autresdocuments_document_document_fkey
            references document
            deferrable initially deferred,
    document_dispositionjuridique bigint
        constraint autresdocuments_document_dispositionjrdque_fkey
            references dispositionjuridique
            deferrable initially deferred
);

alter table autresdocuments
    owner to rdppfdb_dbo;

grant insert, select, update, delete on autresdocuments to rdppfdb_edit;

create index if not exists autresdocuments_t_basket_idx
    on autresdocuments (t_basket);

create index if not exists autresdocuments_origine_document_idx
    on autresdocuments (origine_document);

create index if not exists autresdocuments_origine_dispositionjurdque_idx
    on autresdocuments (origine_dispositionjuridique);

create index if not exists autresdocuments_document_document_idx
    on autresdocuments (document_document);

create index if not exists autresdocuments_document_dispositionjrdque_idx
    on autresdocuments (document_dispositionjuridique);

create table if not exists type_document
(
    t_id                             bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint type_document_pkey
            primary key,
    t_basket                         bigint
        constraint type_document_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    atype                            bigint
        constraint type_document_atype_fkey
            references atype
            deferrable initially deferred,
    disposition_document             bigint
        constraint type_document_disposition_document_fkey
            references document
            deferrable initially deferred,
    disposition_dispositionjuridique bigint
        constraint type_document_dispjuridique_fkey
            references dispositionjuridique
            deferrable initially deferred
);

alter table type_document
    owner to rdppfdb_dbo;

grant insert, select, update, delete on type_document to rdppfdb_edit;

create index if not exists type_document_t_basket_idx
    on type_document (t_basket);

create index if not exists type_document_atype_idx
    on type_document (atype);

create index if not exists type_document_disposition_document_idx
    on type_document (disposition_document);

create index if not exists type_document_disposition_dispostnjrdque_idx
    on type_document (disposition_dispositionjuridique);

create table if not exists plansdf95_v1_1geodonneesdebase_type_document
(
    t_id                                                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint plansdf95_v1_1geodonneesdebase_type_document_pkey
            primary key,
    t_basket                                             bigint
        constraint plansdf95_v1_bs_typ_dcment_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    atype                                                bigint
        constraint plansdf95_v1_bs_typ_dcment_atype_fkey
            references plansdf95_v1_1geodonneesdebase_type
            deferrable initially deferred,
    disposition_plansdf95_v1_1dispositnsjrdques_document bigint
        constraint plansdf95_v1_1geodonneesdebase_type_document_document_fkey
            references document
            deferrable initially deferred,
    disposition_dispositionjuridique                     bigint
        constraint plansdf95_v1_1geodonneesdebase_type_document_dispjuridique_fkey
            references dispositionjuridique
            deferrable initially deferred
);

alter table plansdf95_v1_1geodonneesdebase_type_document
    owner to rdppfdb_dbo;

grant insert, select, update, delete on plansdf95_v1_1geodonneesdebase_type_document to rdppfdb_edit;

create index if not exists plansdf95_v1_bs_typ_dcment_t_basket_idx
    on plansdf95_v1_1geodonneesdebase_type_document (t_basket);

create index if not exists plansdf95_v1_bs_typ_dcment_atype_idx
    on plansdf95_v1_1geodonneesdebase_type_document (atype);

create index if not exists plansdf95_v1_bs_typ_dcment_dispstn_plnsdsjrdqs_dcment_idx
    on plansdf95_v1_1geodonneesdebase_type_document (disposition_plansdf95_v1_1dispositnsjrdques_document);

create index if not exists plansdf95_v1_bs_typ_dcment_dispstn_plnsd_dspstnjrdque_idx
    on plansdf95_v1_1geodonneesdebase_type_document (disposition_dispositionjuridique);

create table if not exists degrdsn95_v1_1geodonneesdebase_type_document
(
    t_id                                                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint degrdsn95_v1_1geodonneesdebase_type_document_pkey
            primary key,
    t_basket                                             bigint
        constraint degrdsn95_v1_bs_typ_dcment_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    disposition_degrdsn95_v1_1dispositnsjrdques_document bigint
        constraint degrdsn95_v1_1geodonneesdebase_type_document_document_fkey
            references document
            deferrable initially deferred,
    disposition_dispositionjuridique                     bigint
        constraint degrdsn95_v1_1geodonneesdebase_type_document_dispjuridique_fkey
            references dispositionjuridique
            deferrable initially deferred,
    atype                                                bigint
        constraint degrdsn95_v1_bs_typ_dcment_atype_fkey
            references degrdsn95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table degrdsn95_v1_1geodonneesdebase_type_document
    owner to rdppfdb_dbo;

grant insert, select, update, delete on degrdsn95_v1_1geodonneesdebase_type_document to rdppfdb_edit;

create index if not exists degrdsn95_v1_bs_typ_dcment_t_basket_idx
    on degrdsn95_v1_1geodonneesdebase_type_document (t_basket);

create index if not exists degrdsn95_v1_bs_typ_dcment_dispstn_dgrdssjrdqs_dcment_idx
    on degrdsn95_v1_1geodonneesdebase_type_document (disposition_degrdsn95_v1_1dispositnsjrdques_document);

create index if not exists degrdsn95_v1_bs_typ_dcment_dispstn_dgrds_dspstnjrdque_idx
    on degrdsn95_v1_1geodonneesdebase_type_document (disposition_dispositionjuridique);

create index if not exists degrdsn95_v1_bs_typ_dcment_atype_idx
    on degrdsn95_v1_1geodonneesdebase_type_document (atype);

create table if not exists limtsdl95_v1_1geodonneesdebase_type_document
(
    t_id                                                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint limtsdl95_v1_1geodonneesdebase_type_document_pkey
            primary key,
    t_basket                                             bigint
        constraint limtsdl95_v1_bs_typ_dcment_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    disposition_limtsdl95_v1_1dispositnsjrdques_document bigint
        constraint limtsdl95_v1_1geodonneesdebase_type_document_document_fkey
            references document
            deferrable initially deferred,
    disposition_dispositionjuridique                     bigint
        constraint limtsdl95_v1_1geodonneesdebase_type_document_dispjuridique_fkey
            references dispositionjuridique
            deferrable initially deferred,
    atype                                                bigint
        constraint limtsdl95_v1_bs_typ_dcment_atype_fkey
            references limtsdl95_v1_1geodonneesdebase_type
            deferrable initially deferred
);

alter table limtsdl95_v1_1geodonneesdebase_type_document
    owner to rdppfdb_dbo;

grant insert, select, update, delete on limtsdl95_v1_1geodonneesdebase_type_document to rdppfdb_edit;

create index if not exists limtsdl95_v1_bs_typ_dcment_t_basket_idx
    on limtsdl95_v1_1geodonneesdebase_type_document (t_basket);

create index if not exists limtsdl95_v1_bs_typ_dcment_dispstn_lmtsdsjrdqs_dcment_idx
    on limtsdl95_v1_1geodonneesdebase_type_document (disposition_limtsdl95_v1_1dispositnsjrdques_document);

create index if not exists limtsdl95_v1_bs_typ_dcment_dispstn_lmtsd_dspstnjrdque_idx
    on limtsdl95_v1_1geodonneesdebase_type_document (disposition_dispositionjuridique);

create index if not exists limtsdl95_v1_bs_typ_dcment_atype_idx
    on limtsdl95_v1_1geodonneesdebase_type_document (atype);

create table if not exists typzr_document
(
    t_id                                                 bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint typzr_document_pkey
            primary key,
    t_basket                                             bigint
        constraint typzr_document_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    typezr                                               bigint
        constraint typzr_document_typezr_fkey
            references type_zonereservee
            deferrable initially deferred,
    disposition_zons_rsmn95_v1dispositnsjrdques_document bigint
        constraint typzr_document_document_fkey
            references document
            deferrable initially deferred,
    disposition_dispositionjuridique                     bigint
        constraint typzr_document_dispjuridique_fkey
            references dispositionjuridique
            deferrable initially deferred
);

alter table typzr_document
    owner to rdppfdb_dbo;

grant insert, select, update, delete on typzr_document to rdppfdb_edit;

create index if not exists typzr_document_t_basket_idx
    on typzr_document (t_basket);

create index if not exists typzr_document_typezr_idx
    on typzr_document (typezr);

create index if not exists typzr_document_dispstn_zns_rsjrdqs_dcment_idx
    on typzr_document (disposition_zons_rsmn95_v1dispositnsjrdques_document);

create index if not exists typzr_document_dispstn_zns_r_dspstnjrdque_idx
    on typzr_document (disposition_dispositionjuridique);

grant insert, select, update, delete on chcantoncode to rdppfdb_edit;

create table if not exists etat_equipement
(
    t_id        bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint etat_equipement_pkey
            primary key,
    thisclass   varchar(1024),
    baseclass   varchar(1024),
    itfcode     integer,
    ilicode     varchar(1024),
    seq         integer,
    inactive    boolean,
    dispname    varchar(250),
    description varchar(1024)
);

alter table etat_equipement
    owner to rdppfdb_dbo;

create table if not exists etatdelequipement
(
    t_id                  bigint default nextval('normat.t_ili2db_seq'::regclass) not null
        constraint etatdelequipement_pkey
            primary key,
    t_basket              bigint
        constraint etatdelequipement_t_basket_fkey
            references t_ili2db_basket
            deferrable initially deferred,
    t_ili_tid             varchar(200),
    geometrie             geometry(Polygon, 2056),
    etat_construction     bigint
        constraint etatdelequipement_etat_construction_fkey
            references etat_construction
            deferrable initially deferred,
    etat_equipement       bigint
        constraint etatdelequipement_etat_equipement_fkey
            references etat_equipement
            deferrable initially deferred,
    aptitude_construction bigint
        constraint etatdelequipement_aptitude_construction_fkey
            references aptitude_construction
            deferrable initially deferred,
    remarques             text
);

alter table etatdelequipement
    owner to rdppfdb_dbo;

grant insert, select, update, delete on etatdelequipement to rdppfdb_edit;

create index if not exists etatdelequipement_t_basket_idx
    on etatdelequipement (t_basket);

create index if not exists etatdelequipement_geometrie_idx
    on etatdelequipement (geometrie);

create index if not exists etatdelequipement_etat_construction_idx
    on etatdelequipement (etat_construction);

create index if not exists etatdelequipement_etat_equipement_idx
    on etatdelequipement (etat_equipement);

create index if not exists etatdelequipement_aptitude_construction_idx
    on etatdelequipement (aptitude_construction);

grant insert, select, update, delete on etat_equipement to rdppfdb_edit;

create table if not exists t_ili2db_classname
(
    iliname varchar(1024) not null
        constraint t_ili2db_classname_pkey
            primary key,
    sqlname varchar(1024) not null
);

alter table t_ili2db_classname
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_classname to rdppfdb_edit;

create table if not exists t_ili2db_attrname
(
    iliname  varchar(1024) not null,
    sqlname  varchar(1024) not null,
    colowner varchar(1024) not null,
    target   varchar(1024)
);

alter table t_ili2db_attrname
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_attrname to rdppfdb_edit;

create unique index if not exists t_ili2db_attrname_sqlname_colowner_key
    on t_ili2db_attrname (sqlname, colowner);

create table if not exists t_ili2db_column_prop
(
    tablename  varchar(255)  not null,
    subtype    varchar(255),
    columnname varchar(255)  not null,
    tag        varchar(1024) not null,
    setting    varchar(8000) not null
);

alter table t_ili2db_column_prop
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_column_prop to rdppfdb_edit;

create table if not exists t_ili2db_table_prop
(
    tablename varchar(255)  not null,
    tag       varchar(1024) not null,
    setting   varchar(8000) not null
);

alter table t_ili2db_table_prop
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_table_prop to rdppfdb_edit;

create table if not exists t_ili2db_meta_attrs
(
    ilielement varchar(255)  not null,
    attr_name  varchar(1024) not null,
    attr_value varchar(8000) not null
);

alter table t_ili2db_meta_attrs
    owner to rdppfdb_dbo;

grant insert, select, update, delete on t_ili2db_meta_attrs to rdppfdb_edit;

