<template>
  <v-card class="background rounded-xl card">
    <div class="top">
      <div class="icon">
        <v-img width="60" :src="require('../assets/DICE-FMTLP.png')" />
      </div>
      <div class="right">
        <div class="font-weight-bold text-h5">DICE-FTM LP</div>
        <div class="secondary px-2 py-1 rounded-xl">BEST</div>
      </div>
    </div>
    <div class="body">
      <div>
        <div class="body__item">
          <div>APR:</div>
          <div>000.00%</div>
        </div>
        <div class="body__item">
          <div>Earn:</div>
          <div>DICE</div>
        </div>
        <div class="body__item">
          <div>Deposit Fee:</div>
          <div class="secondary px-2 py-1 rounded-xl">0%</div>
        </div>
      </div>
      <div class="my-3">
        <div class="secondary--text subtitle-2">DICE EARNED</div>
        <div class="body__item">
          <div class="text-h4 grey--text">0</div>
          <div class="grey px-4 py-2 rounded-xl">Harvest (CLAIM DICE)</div>
        </div>
      </div>
      <div class="my-4">
        <div class="secondary--text subtitle-2">DICE-FTM LP STAKED</div>
        <v-btn
          block
          large
          rounded
          color="primary"
          class="my-2"
          @click="unlockWallet()"
          >{{farmStatus}}</v-btn
        >
      </div>
    </div>
    <v-divider></v-divider>
    <v-expansion-panels flat>
      <v-expansion-panel class="transparent">
        <v-expansion-panel-header>Details</v-expansion-panel-header>
        <v-expansion-panel-content>
          <div class="body__item">
            <div>Deposit:</div>
            <div>DICE-FTM LP</div>
          </div>
          <div class="body__item">
            <div>Total Liquidity:</div>
            <div>$000,000,000</div>
          </div>
          <div class="body__item">
            <div>LP price:</div>
            <div>~0</div>
          </div>
        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-expansion-panels>
    <v-dialog v-model="dialog" width="500">
      <v-card class="rounded-xl card" color="background" flat elevation="0">
        <v-app-bar flat color="rgba(0, 0, 0, 0)">
          <v-toolbar-title class="title white--text pl-0">
            Add to Farm
          </v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-app-bar>
        <v-card-text>
          Error Message.
        </v-card-text>
      </v-card>
    </v-dialog>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  data() {
    return {
      dialog: false,
    };
  },
  computed: {
    ...mapGetters({
      farmStatus: 'farmStatus',
    }),
  },
  methods: {
    unlockWallet() {
      if (typeof window.ethereum === "undefined") {
        return;
      }

      window.ethereum.request({
        method: "eth_requestAccounts",
      });
    },
  },
};
</script>

<style scoped>
.card {
  box-sizing: border-box;
  padding: 25px;
}
.top {
  display: flex;
  justify-content: space-between;
}
.top .icon {
}
.top .right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.body {
}
.body__item {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>