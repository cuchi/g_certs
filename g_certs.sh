#!/bin/bash
#
# Copyright 2015 Paulo Henrique Cuchi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

################## Inclua os dados aqui ###################

data="25 de Abril de 2015"
local="na UDESC - CCT"
cidade="Joinville"
evento="FLISoL"
num_horas="5"

###########################################################

template="template.svg"
temp_aux="template.aux.svg"
lst_part="participantes.txt"
cert_dir="certificados"

[ -e $template ] || exit 1
[ -e $lst_part ] || exit 2
[ -d $cert_dir ] || mkdir $cert_dir || exit 3
[ -e /bin/inkscape ] || exit 4

cp $template $temp_aux

sed -i 's/_DATA_/'"$data"'/g'           $temp_aux
sed -i 's/_LOCAL_/'"$local"'/g'         $temp_aux
sed -i 's/_CIDADE_/'"$cidade"'/g'       $temp_aux
sed -i 's/_EVENTO_/'"$evento"'/g'       $temp_aux
sed -i 's/_NUM_HORAS_/'"$num_horas"'/g' $temp_aux

while read p; do
    printf "Gerando certificado para %s:\n" "$p"
    certsvg="${p// /_}.svg"
    certpdf="${p// /_}.pdf"
    printf "\tCriando svg...\n"
    cp $temp_aux $certsvg
    printf "\tSubstituindo...\n"
    sed -i 's/_NOME_PARTICIPANTE_/'"$p"'/g' $certsvg
    mv $certsvg $cert_dir
    cd $cert_dir
    printf "\tConvertendo para PDF...\n"
    inkscape $certsvg --export-pdf=$certpdf
    rm $certsvg
    cd ..
    printf "Pronto!\n"
done < $lst_part

rm $temp_aux
