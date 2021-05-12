<template>
  <div>
    <v-container>
      <div class="items">
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" height=300 outlined>
          </v-card>
        </div>
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
          </v-card>
        </div>
      </div>
      <div class="items">
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" height=300 outlined>
          </v-card>
        </div>
        <div class="items__item">
          <v-card class="rounded-xl card" color="background" outlined>
          </v-card>
        </div>
      </div>
    </v-container>
  </div>
</template>

<script>
import { CUSTOM_NETWORK } from "../../config";
export default {
  data() {
    return {};
  },
  methods: {
    async unlockWallet() {
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
  position: relative;
  height: 100%;
}

.bg {
  position: absolute;
  top: 70px;
  right: 30px;
  opacity: 0.4;
}

.items {
  display: flex;
  justify-content: center;
}

.items__item {
  max-width: 400px;
  width: 100%;
  margin: 20px;
}

@media (max-width: 900px) {
  .card {
    position: relative;
    height: 100%;
  }

  .items {
    display: flex;
    justify-content: center;
    flex-direction: column;
  }

  .items__item {
    max-width: 90%;
  }
}
</style>