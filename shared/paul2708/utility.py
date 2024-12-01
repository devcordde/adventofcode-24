from typing import List


def flatten(list_of_lists: List) -> List:
    return [item for single_list in list_of_lists for item in single_list]
