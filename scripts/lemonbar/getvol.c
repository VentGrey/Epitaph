#include <alsa/asoundlib.h>

int main() {
        snd_mixer_t *mixer;

        if (snd_mixer_open(&mixer, 1) ||
            snd_mixer_attach(mixer, "default") ||
            snd_mixer_selem_register(mixer, NULL, NULL) ||
            snd_mixer_load(mixer)) exit(42);

        snd_mixer_selem_id_t *id;

        snd_mixer_selem_id_alloca(&id);

        snd_mixer_selem_id_set_index(id, 0);

        snd_mixer_selem_id_set_name(id, "Master");

        snd_mixer_elem_t *elem = snd_mixer_find_selem(mixer, id);

        if (!elem) {
                exit(5);
        }
        long min, max, vol;

        snd_mixer_selem_get_playback_volume_range(elem, &min, &max);

        snd_mixer_selem_get_playback_volume(elem,
                                            SND_MIXER_SCHN_FRONT_LEFT, &vol);

        printf("%li%%", ((vol - min)*100 + (max - min)/2) / (max - min));
        snd_mixer_close(mixer);
}
