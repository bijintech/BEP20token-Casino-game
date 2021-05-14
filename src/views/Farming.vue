<template>
  <div>
        <v-card color="background" flat :class="$vuetify.theme.isDark ? 'rounded-0 pa-3' : 'rounded-0 pa-3 bgm'">
            <v-card-title class="text-sm-h5  text-xs-h6 font-weight-bold secondary--text">Add your FTM DICE LP to Farming to EARN DICE
            </v-card-title>
            <v-card-text>
            <div>Powered by the fastest blockchain Fantom</div>
          </v-card-text>
        </v-card>
      <v-container>
        <Items />
      </v-container>
  </div>
</template>

<script>
import Items from "@/components/Items";
export default {
  components: { Items },
};
</script>

<style>
</style>