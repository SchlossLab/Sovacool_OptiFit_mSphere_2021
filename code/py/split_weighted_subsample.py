#!/usr/local/bin/python3
import Bio.SeqIO
from collections import defaultdict
import numpy as np


def main():
    numpy.random.seed(wildcards.seed)
    for src, dest in [[input.fasta, output.fasta],
                      [input.count, output.count],
                      [input.dist, output.dist]
                      ]:
        shutil.copyfile(src, dest)
    sample_size = round(wildcards.sample_frac * seq_list.len, 0)
    ref_size = round(wildcards.ref_frac * seq_list.len, 0)

    all_seqs = SeqList.get_seqs(input.fasta, input.count, input.dist)
    ref_list = all_seqs.get_sample(ref_size, wildcards.ref_weight)
    ref_list.write_ids(output.ref_accnos)
    
    remaining_seqs = seq_list.set_diff(all_seqs, ref_list)
    sample_list = remaining_seqs.get_sample(sample_size, 'simple')
    sample_list.write_ids(output.sample_accnos)

class MetaSeq:
    def __init__(self, seq_id, avg_abun, avg_dist, seq_record):
        self.seq_id = seq_id
        self.avg_abun = avg_abun
        self.avg_dist = avg_dist
        self.seq_record = seq_record

    @property
    def avg_sim():
        return 1 - avg_dist


class SeqList:
    def __init__(self, seqs):
        self.seqs = seqs

    @property
    def len():
        return len(self.seqs)

    @property
    def ids():
        return [seq.seq_id for seq in self.seqs]

    @property
    def scaled_abuns():
        total_abun = sum(seq.avg_abun for seq in self.seqs)
        return [seq.avg_abun / total_abun for seq in self.seqs]

    @property
    def scaled_dists():
        total_dist = sum(seq.avg_dist for seq in self.seqs)
        return [seq.avg_dist / total_dist for seq in self.seqs]

    @property
    def scaled_sims():
        return [dist - 1 for dist in self.scaled_dists]

    @classmethod
    def get_seqs(fasta_fn, count_fn, dist_fn):
        with open(fasta_fn, 'r') as fasta_file:
            seq_dict = {seq_record.id: MetaSeq(seq_record.id, np.nan, np.nan, seq_record)
                        for seq_record in Bio.SeqIO.read(fasta_file, 'fasta')}
        with open(count_fn, 'r') as count_file:
            line = next(count_file)
            for line in count_file:
                line = line.strip().split('\t')
                seq_id = line[0]
                seq_dict[seq_id].avg_abun = np.mean(float(count) for count in line[1:])
        with open(dist_fn, 'r') as dist_file:
            line = next(count_file)
            distances = defaultdict(list)
            for line in file:
                line = line.strip().split('\t')
                seq_id1 = line[0]
                seq_id2 = line[1]
                dist = float(line[2])
                distances[seq_id1].append(dist)
                distances[seq_id2].append(dist)
        for seq_id in distances:
            seq_dict[seq_id].avg_dist = np.mean(distances[seq_id])
        return SeqList(list(sorted(seq_dict.values(), key=lambda seq: seq.seq_id)))

    @classmethod
    def set_diff(lhs, rhs):
        return SeqList([seq for seq in lhs.seqs if seq.seq_id not in rhs.ids])

    def get_sample(self, sample_size, weight_method):
        random_weight_probs = {'simple': None,
                               'abundance': self.scaled_abuns,
                               'distance': self.scaled_dists
                               }
        sample_seqs = np.random.choice(self.seqs,
                                       replace = False,
                                       size = sample_size,
                                       p = random_weight_probs[weight_method]
                                       )
        return SeqList(sample_seqs)

    def write_ids(self, output_fn):
        with open(output_fn, 'w') as outfile:
            for seq_id in self.ids:
                outfile.write(f"{seq_id}\n")


main()