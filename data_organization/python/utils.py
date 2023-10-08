import re


def fix_file_paths(df_files):
    df_files = df_files.rename(columns={df_files.columns[1]: 'timestamps', df_files.columns[0]: 'lfp', })

    return df_files


def extract_ratnum_from_file_name(filename):
    filename = filename.replace(' ', '')
    match = re.search(r"rat(\d{1,2})", filename.lower())
    if not match:
        match = re.search(r"ray(\d{1,2})", filename.lower())

    if match:
        number = int(match.group(1))
    else:
        number = -1
    return number


def extract_daynum_from_file_name(filename):
    filename = filename.replace(' ', '')
    match = re.search(r"day(\d{1,2})", filename.lower())
    if not match:
        match = re.search(r"days(\d{1,2})", filename.lower())
    if not match:
        match = re.search(r"dat(\d{1,2})", filename.lower())


    if match:
        number = int(match.group(1))
    else:
        number = -1
    return number


def extract_probe_number_from_file_name(filename):
    filename = filename.replace(' ', '')
    match = re.search(r"probe(\d{1,2})", filename.lower())
    if match:
        number = int(match.group(1))
    else:
        number = -1
    return number


def extract_paradigm_from_file_name(filename):
    filename = filename.replace(' ', '')
    if 'free' in filename.lower():
        paradigm = 'free'
    elif 'chamber' in filename.lower():
        paradigm = 'chamber'
    else:
        paradigm = 'unk'
    return paradigm

def extract_sociability_from_file_name(filename):
    filename = filename.replace(' ', '')
    if 'affiliative' in filename.lower():
        sociability = 'affiliative'
    elif 'aversive' in filename.lower():
        sociability = 'aversive'
    else:
        if extract_paradigm_from_file_name(filename) == 'free':
            sociability = 'free_unk'
        else:
            sociability = 'unk'
    return sociability

def extract_details_from_file_names(filename):
    rat_number = extract_ratnum_from_file_name(filename)
    day_number = extract_daynum_from_file_name(filename)
    probe_number = extract_probe_number_from_file_name(filename)
    paradigm = extract_paradigm_from_file_name(filename)
    sociablity = extract_sociability_from_file_name(filename)
    return {'rat_number': rat_number, 'day_number': day_number, 'probe_number': probe_number, 'paradigm':paradigm,
            'sociability': sociablity}
