<template>
  <div class="items">
      <ItemGrid class="items__item" />
  </div>
</template>

<script>
import ItemGrid from '@/components/ItemGrid'
export default {
    components: { ItemGrid }
}
</script>

<style scoped>
.items{
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    /* gap: 10px; */
    box-sizing: content-box;
}
.items__item{
    margin: 10px;
    border: 1px solid red;
    width: 100%;
    max-width: 350px;
    min-width: 40%;
}



</style>