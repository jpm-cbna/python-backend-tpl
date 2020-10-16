"""Initial migration.

Revision ID: 70288eea9cf6
Revises:
Create Date: 2020-05-28 23:12:19.389143

"""
import os, re

from alembic import op
import sqlalchemy as sa

from shared import config
from api.descriptions.entities import Description

# revision identifiers, used by Alembic.
revision = '70288eea9cf6'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    print('### Adding table "descriptions".')
    op.create_table(
        'description',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('mnemonic', sa.String(length=250), nullable=False),
        sa.Column('rank', sa.String(length=50), nullable=False),
        sa.Column('raw_text', sa.Text(), nullable=False),
        sa.Column('order', sa.String(length=5), nullable=True),
        sa.Column('sciname', sa.String(length=150), nullable=True),
        sa.Column('relationships', sa.Text(), nullable=True),
        sa.Column('zoobank', sa.String(length=250), nullable=True),
        sa.Column('type_locality', sa.Text(), nullable=True),
        sa.Column('material_examined', sa.Text(), nullable=True),
        sa.Column('diagnosis', sa.Text(), nullable=True),
        sa.Column('description', sa.Text(), nullable=True),
        sa.Column('subtaxa', sa.Text(), nullable=True),
        sa.Column('bionomics', sa.Text(), nullable=True),
        sa.Column('distribution', sa.Text(), nullable=True),
        sa.Column('etymology', sa.Text(), nullable=True),
        sa.Column('comments', sa.Text(), nullable=True),
        sa.Column('meta_user_id', sa.Integer(), nullable=True),
        sa.Column('meta_date', sa.DateTime(), server_default=sa.text('(CURRENT_TIMESTAMP)'), nullable=True),
        sa.Column('meta_state', sa.String(), server_default=sa.text('A'), nullable=True),
        sa.PrimaryKeyConstraint('id')
    )

    print('### Adding samples descriptions:')
    bind = op.get_bind()
    session = sa.orm.Session(bind=bind)
    cfg = config.get()
    samples_dir = cfg['pathes']['database'] + '/samples'
    file_name_regexp = re.compile('^([0-9]{4})_(G|SP)_([^.]+).txt$')
    for file_name in get_sample_files(samples_dir):
        matched = file_name_regexp.match(file_name)
        file_path = os.path.join(samples_dir, file_name)
        with open(file_path, 'r') as file:
            text = file.read()

        # Create and persist sample descriptions
        print(f'\tAdd {file_name}')
        desc = Description(matched.group(3), matched.group(2), text, 1)
        session.add(desc)

    session.commit()
    session.close()

def get_sample_files(path):
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
            yield file

def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('description')
    # ### end Alembic commands ###
